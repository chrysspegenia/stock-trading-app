class TraderMailer < ApplicationMailer
    default from: 'admin_stock_app@email.com'

    def approved_email
        @trader = params[:user]
        @url = 'http://127.0.0.1:3000/users/sign_in' #modify link when deployed. This link directs to login page
        mail(to: @trader.email, subject: 'Account Approval')
    end
end
