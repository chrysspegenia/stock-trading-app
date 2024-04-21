class TradersController < ApplicationController
    before_action :check_approval_status, only: [:buy_new, :buy, :sell_new, :sell, :portfolio, :transaction]
    helper_method :get_logo, :iex_client


    def index
        @trader = current_user
        @quotes = iex_client.stock_market_list(:mostactive)
    end

    def show
        @quote = iex_client.quote(params[:id])
        @logo = iex_client.logo(params[:id])
    end

    def portfolio
      @trader = current_user
      @stocks = current_user.stocks.all
    end

    def transaction
      @trader = current_user
      @transactions = current_user.transactions.all
    end

    def buy_new
      @quote = iex_client.quote(params[:format])
      @company = iex_client.company(params[:format])
    end

    def buy
      symbol, quantity, action = params.values_at(:symbol, :quantity, :action)
      quantity = quantity.to_i
      price = BigDecimal(iex_client.quote(symbol).latest_price.to_s)
      total_amount = quantity * price
      stock = Stock.create_or_update_stock(symbol, current_user, iex_client)

      if total_amount <= current_user.balance
        transaction = Transaction.create_transaction(current_user, stock, quantity, price, action, total_amount)

        if transaction.save
          Stock.update_quantity(stock, quantity, price)
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

    def sell_new
      @quote = iex_client.quote(params[:format])
      @company = iex_client.company(params[:format])
    end

    def sell
      symbol, quantity, action = params.values_at(:symbol, :quantity, :action)
      quantity = quantity.to_i
      price = BigDecimal(iex_client.quote(symbol).latest_price.to_s)
      total_amount = quantity * price
      stock = Stock.find_by(symbol: symbol, user_id: current_user.id)

      if stock && stock.shares >= quantity
        transaction = Transaction.create_transaction(current_user, stock, quantity, price, action, total_amount)

        if transaction.save
          Stock.update_quantity(stock, -quantity, price)
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

    private

    def iex_client
       @iex_client ||= IEX::Api::Client.new
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
