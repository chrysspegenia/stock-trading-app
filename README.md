# Project: Stock Trading App

## Requirements

### Admin

- [x] I want to create a new trader to manually add them to the app
- [x] I want to edit a specific trader to update his/her details
- [x] I want to view a specific trader to show his/her details
- [x] I want to see all the trader that registered in the app so I can track all the traders
- [x] I want to have a page for pending trader sign up to easily check if there's a new trader sign up
- [x] I want to approve a trader sign up so that he/she can start adding stocks
- [x] I want to see all the transactions so that I can monitor the transaction flow of the app.

### Trader

- [x] I want to create an account to buy and sell stocks
- [x] I want to log in my credentials so that I can access my account on the app
- [x] I want to receive an email to confirm my pending Account signup
- [x] I want to receive an approval Trader Account email to notify me once my account has been approved
- [x] I want to buy a stock to add to my investment (Signup should be approved)
- [x] I want to have a My Portfolio page to see all my stocks
- [x] I want to have a Transaction page to see and monitor all the transactions made by buying and selling stocks
- [x] I want to sell my stocks to gain money

## Gems used

- [Boxicons](https://boxicons.com/usage)
- [IEX Ruby Client - IEX Finance API](https://github.com/dblock/iex-ruby-client)
- [Whenever Gem](https://github.com/javan/whenever)

## Resouces

- [Devise Wiki - Admin Role](https://github.com/heartcombo/devise/wiki/How-To:-Add-an-Admin-Role)
- [Devise Wiki - Confirmable](https://github.com/heartcombo/devise/wiki/How-To:-Add-:confirmable-to-Users)
- [Hotrails - TurboFrame & TurboStream](https://www.hotrails.dev/turbo-rails/turbo-frames-and-turbo-streams)
- [Action Mailer Configuration](https://guides.rubyonrails.org/action_mailer_basics.html#action-mailer-configuration)
- [Rails layout templates](https://medium.com/@shachsan/how-to-utilize-rails-layouts-to-keep-our-view-templates-less-clutter-1f6f50a1ef29)

## Problems and solutions

- [Devise redirect after login fail](https://stackoverflow.com/questions/5832631/devise-redirect-after-login-fail)
  --Modify devise route when input invalid credentials
- [Devise redirect on sign up failure](https://stackoverflow.com/questions/6240141/devise-redirect-on-sign-up-failure?rq=3)
  --Modify devise route upon invalid registration
