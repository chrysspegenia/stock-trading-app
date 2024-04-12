class UserMailer < ApplicationMailer
  def approval_email(user)
    @user = user
    mail(to: @user.email, subject: 'Your account has been approved')
  end
end
