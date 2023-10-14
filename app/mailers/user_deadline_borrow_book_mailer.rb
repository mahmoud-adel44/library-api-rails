class UserDeadlineBorrowBookMailer < ApplicationMailer
  default from: 'admin@library.com'

  def send_email
    # @type[Book]
    @book = params[:book]

    # @type[User]
    @user = params[:user]
    @subject = "The deadline for returning the borrowed book #{@book.name} is one day"
    mail(to: @user.email, subject: "Improtant Email !!!!")
  end
end
