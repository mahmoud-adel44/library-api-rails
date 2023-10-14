# frozen_string_literal: true

# The base controller for all API controllers in the application.
# Provides common functionality and configuration for all API controllers.
# Inherits from `ActionController::API`.
class ApiApplicationController < ActionController::API
  include ExceptionHandler

  around_action :switch_locale
  before_action :authorize_request
  before_action :check_user_verfied, except: [:authorize_request]

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def response_success(data: [], status: :ok)
    render json: {
      data:,
      message: I18n.t('success_action')
    }, status:
  end

  def response_faild(errors: [], status: :server_error)
    render json: {
      data: [],
      errors:,
      message: I18n.t('failed_action')
    }, status:
  end

  def authorize_request
    raise MissingToken.new(error: 'unauthorized') unless request.headers.include?('Authorization')

    header = request.headers['Authorization']
    header = header.split(' ').last if header
    @decoded = JsonWebToken.decode(header)
    @current_user = User.find(@decoded[:user_id])
  end

  private

  def check_user_verfied
    raise AccountNotVerified.new(error: 'un_verifyed_email') if @current_user&.is_unverifyed
  end
end
