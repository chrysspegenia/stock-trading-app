class TradersController < ApplicationController
    before_action :check_approval_status, only: [:buy_new, :buy, :sell_new, :sell, :balance, :balance_new]
    before_action :set_trader, only: [:index, :show, :portfolio, :transaction, :buy_new, :sell_new, :balance_new]
    helper_method :get_logo, :iex_client

    #GET /traders
    def index
        @quotes = iex_client.stock_market_list(:mostactive)
    end

    #GET traders/:symbol   ... :symbol value is the params[:id]
    def show
        @company = iex_client.company(params[:id])
        @logo = iex_client.logo(params[:id])
    end

    #GET traders/:id/portfolio
    def portfolio
      @stocks = current_user.stocks.all
    end

    #GET traders/:id/transaction
    def transaction
      @transactions = current_user.transactions.all
    end

    #GET /traders/:symbol/buy_new  ... :symbol value is the params[:id]
    def buy_new
      @quote = iex_client.quote(params[:id])
    end

    #POST /traders/:id/buy
    def buy
      symbol, quantity, action = params.values_at(:symbol, :quantity, :action)
      quantity = quantity.to_i
      price = BigDecimal(iex_client.quote(symbol).latest_price.to_s)
      total_amount = quantity * price
      stock = Stock.create_or_update_stock(symbol, current_user, iex_client)

      if total_amount <= current_user.balance
        transaction = Transaction.create_transaction(current_user, stock, quantity, price, action, total_amount)

        if transaction.save
          Stock.update_portfolio(stock, quantity, price)
          User.update_balance(current_user, action, total_amount)
          flash[:notice] = 'Transaction created successfully.'
        else
          flash[:alert] = 'Transaction failed to save.'
        end
      else
        flash[:alert] = 'Insufficient balance to make the purchase.'
      end

      redirect_to traders_path
    end

    #GET /traders/:symbol/sell_new  ... :symbol value is the params[:id]
    def sell_new
      @quote = iex_client.quote(params[:id])
      @company = iex_client.company(params[:id])
    end

    #POST /traders/:id/sell
    def sell
      symbol, quantity, action = params.values_at(:symbol, :quantity, :action)
      quantity = quantity.to_i
      price = BigDecimal(iex_client.quote(symbol).latest_price.to_s)
      total_amount = quantity * price
      stock = Stock.find_by(symbol: symbol, user_id: current_user.id)

      if stock && stock.shares >= quantity
        transaction = Transaction.create_transaction(current_user, stock, quantity, price, action, total_amount)

        if transaction.save
          Stock.update_portfolio(stock, -quantity, price)
          User.update_balance(current_user, action, total_amount)
          flash[:notice] = 'Transaction created successfully.'
        else
          flash[:alert] = 'Transaction failed to save.'
        end
      else
        flash[:alert] = 'Insufficient quantity of shares to sell.'
      end

      redirect_to traders_path
    end

    #GET /traders/:id/balance_new
    def balance_new
      @balance = (params[:format])
    end

    #POST /traders/:id/balance
    def balance
      if current_user.update(balance: params[:init_balance])
        flash[:notice] = 'Wallet balance has been successfully set.'
      else
        flash[:alert] = 'Failed to save the wallet balance.'
      end
      redirect_to traders_path
    end

    private

    def iex_client
       @iex_client ||= IEX::Api::Client.new
    end

    def set_trader
      @trader = current_user
    end

    def get_logo(symbol)
      iex_client.logo(symbol).url
    end

    def check_approval_status
      unless current_user.approved?
        flash[:alert] = 'You are not approved to perform this action.'
        redirect_to traders_path
      end
    end
  end
