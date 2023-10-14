class Api::AuthenticationController < ApiApplicationController
  skip_before_action :authorize_request, only: [:login, :register, :confim_email]
  skip_before_action :check_user_verfied , only: [:login, :register, :confim_email]
  after_action :send_confimation_email, only: :register

  def login
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      ttl = Time.now + 24.hours.to_i

      response_success(
        data: {
          token: token,
          expire_at: ttl.strftime("%m-%d-%Y %H:%M"),
          user: UserSerializer.new(@user).serializable_hash
        },
        status: :ok
      )
    else
      response_faild(
        errors: I18n.t('unauthorized'),
        status: :unauthorized
      )
    end
  end

  def register
    @user = User.create!(
      params.permit(:name, :email, :password, :password_confirmation)
    )

    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      ttl = Time.now + 30.days.from_now.to_i

      response_success(
        data: { token: token, expire_at: ttl.strftime("%m-%d-%Y %H:%M"), user: @user },
        status: :ok
      )
    else
      response_faild(
        errors: I18n.t(:unauthorized),
        status: :unauthorized
      )
    end
  end

  def confim_email
    user = User.find_by(email: params[:email])
    user.mark_as_verified

    response_success(
      data: UserSerializer.new(user).serializable_hash,
      status: :ok
    )
  end

  private

  def send_confimation_email
    ConfirmationEmailMailer.with(user: @user).confirmation_email.deliver_later
  end
end
