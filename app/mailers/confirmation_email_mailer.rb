class ConfirmationEmailMailer < ApplicationMailer
  default from: 'admin@library.com'

  def confirmation_email
    @user = params[:user]
    @url  = "http://127.0.0.1:3000/auth/confirmation-email/?email=#{@user.email}"
    mail(to: @user.email, subject: 'Please Confirm Your Accont')
  end
end
