class TraderMailer < ApplicationMailer
    default from: 'admin_stock_app@email.com'

    def approved_email
        @trader = params[:user]
        @url = 'https://stock-trading-app-development-3wka.onrender.com' #modify link when deployed. This link directs to login page
        mail(to: @trader.email, subject: 'Account Approval')
    end
end
