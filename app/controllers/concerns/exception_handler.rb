# frozen_string_literal: true

module ExceptionHandler
  # provides the more graceful `included` method
  extend ActiveSupport::Concern
  class BaseException < StandardError
    attr_reader :error
    attr_reader :message
    attr_reader :data
    def initialize(error: "", message: "", data: {}, params: {})
      @message = message.present? ? message : I18n.t("errors.#{error}")
      @error = error
      @data = data
    end
  end
  # Define custom error subclasses - rescue catches `StandardErrors`
  class AuthenticationError < BaseException; end
  class MissingToken < BaseException; end
  class InvalidToken < BaseException; end
  class InvalidDeviceId < BaseException; end
  class InvalidUserData < BaseException; end
  class InvalidCode < BaseException; end
  class GuestUnAuthorized < BaseException; end
  class InvalidParameters < BaseException; end
  class ArgumentError < BaseException; end
  class AccountNotFound < BaseException; end
  class UnAuthorized < BaseException; end
  class AccountNotVerified < BaseException; end
  class DuplicateRecord < BaseException; end
  class Forbidden < BaseException; end
  class UnprocessableEntity < BaseException; end
  included do
    rescue_from ExceptionHandler::GuestUnAuthorized, with: :guest_not_allowed
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::AccountNotFound, with: :not_found
    rescue_from ActionController::RoutingError, with: :not_found
    rescue_from ExceptionHandler::MissingToken, with: :unauthorized_request
    rescue_from ExceptionHandler::InvalidToken, with: :unauthorized_request
    rescue_from JWT::VerificationError, with: :unauthorized_request
    rescue_from ExceptionHandler::InvalidDeviceId, with: :four_twenty_two
    rescue_from ExceptionHandler::AccountNotVerified, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidUserData, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidCode, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidParameters, with: :invalid_parameters
    rescue_from ExceptionHandler::ArgumentError, with: :invalid_parameters
    rescue_from ExceptionHandler::Forbidden, with: :access_forbidden
    rescue_from ExceptionHandler::DuplicateRecord, with: :four_twenty_two
    rescue_from ActionController::RoutingError, with: :not_found
    rescue_from ActionController::ParameterMissing, with: :missing_parameters
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from ExceptionHandler::UnprocessableEntity, with: :four_twenty_two
    rescue_from I18n::InvalidLocale, with: :catch_invalid_locale
  end
  private
  # JSON response with message; Status code 422 - unprocessable entity
  def response_json_error(error:, message:, status:)
    render json: {
      message: message,
      error: error
    }, status: status
  end

  def four_twenty_two(e)
    excep_logger.info("442 #{e.message}")
    excep_logger.info("Full trace #{e.backtrace.join("\n")}")
    error = e.respond_to?(:error) ? e.error : e.message
    response_json_error(error: e.message, message: I18n.t(:failed_action), status: :unprocessable_entity)
  end
  def something_went_wrong(e)
    excep_logger.info("Something went wrong #{ I18n.t(:failed_action)}")
    excep_logger.info("Full trace #{e.backtrace.join("\n")}")
    response_json_error(error: "Something went wrong", message: "Something went wrong", status: :unprocessable_entity)
  end
  # JSON response with message; Status code 401 - Unauthorized
  def unauthorized_request(e)
    excep_logger.info("Unauthorized #{ I18n.t(:failed_action)}")
    excep_logger.info("Full trace #{e.backtrace.join("\n")}")
    response_json_error(error: e.message, message:  I18n.t(:failed_action), status: :unauthorized)
  end
  def fb_request(e)
    excep_logger.info("FB request #{ I18n.t(:failed_action)}")
    excep_logger.info("Full trace #{e.backtrace.join("\n")}")
    response_json_error(error: e.error, message:  I18n.t(:failed_action), status: e.http_status)
  end
  # JSON response with message; Status code 417 - Expectation Failed
  def invalid_parameters(e)
    excep_logger.info("Invalid Params #{ I18n.t(:failed_action)}")
    excep_logger.info("Full trace #{e.backtrace.join("\n")}")
    response_json_error(error: e.error, message:  I18n.t(:failed_action), status: :expectation_failed)
  end

  # @param[ActionController::ParameterMissing] e
  def missing_parameters(e)
    puts e.message
    excep_logger.info("Missing Params #{ I18n.t(:failed_action)}")
    excep_logger.info("Full trace #{e.backtrace.join("\n")}")
    error = e.respond_to?(:error) ? e.error :  I18n.t(:failed_action)
    response_json_error(error: error, message:  I18n.t(:failed_action), status: :expectation_failed)
  end
  # JSON response with message; Status code 405 - Method Not Allowed
  def guest_not_allowed(e)
    excep_logger.info("Guest not allowed #{ I18n.t(:failed_action)}")
    excep_logger.info("Full trace #{e.backtrace.join("\n")}")
    response_json_error(error: e.error, message:  I18n.t(:failed_action), status: :method_not_allowed)
  end
  # JSON response with message; Status code 404 - Not Found
  def not_found(e)
    excep_logger.info("Record not found #{ I18n.t(:failed_action)}")
    excep_logger.info("Full trace #{e.backtrace.join("\n")}")
    error = e.respond_to?(:error) ? e.error :  I18n.t(:failed_action)
    response_json_error(error: error, message:  I18n.t(:failed_action), status: :not_found)
  end
  # JSON response with message; Status code 500 - Internal Server Error
  def default_error(e)
    excep_logger.info("Default Error #{ I18n.t(:failed_action)}")
    excep_logger.info("Full trace #{e.backtrace.join("\n")}")
    response_json_error(error: e.error, message:  I18n.t(:failed_action), status: :server_error)
  end
  # JSON response with message; Status code 403 - Forbidden
  def access_forbidden(e)
    excep_logger.info("Access Forbidden #{ I18n.t(:failed_action)}")
    excep_logger.info("Full trace #{e.backtrace.join("\n")}")
    response_json_error(error: e.error, message:  I18n.t(:failed_action), status: :forbidden)
  end

  def catch_invalid_locale(e)
    response_json_error(
      error: e.error,
      message: "Not Valid Locale",
      status: :server_error
    )
  end
  def excep_logger
    Logger.new("#{Rails.root}/log/exceptions.log")
  end
end