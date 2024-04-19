class TradersController < ApplicationController
    SYMBOL_NAMES = ['AAPL', 'GOOGL', 'MSFT', 'META', 'AMZN', 'TSLA'].freeze
    before_action :check_approval_status, only: [:buy, :sell]

    def index
        @trader = current_user
        # @stocks = current_user.stocks.all
        # @transactions = current_user.transactions.all
        @quotes = get_quotes(SYMBOL_NAMES)
        @logos = get_logos(SYMBOL_NAMES)
    end

    def show
        @quote = initialize_iex_client.quote(params[:id])
        @logo = initialize_iex_client.logo(params[:id])
        @company = initialize_iex_client.company(params[:id])
    end

    def buy
      symbol, quantity, action = params.values_at(:symbol, :quantity, :action)
      quantity = quantity.to_i
      price = BigDecimal(initialize_iex_client.quote(symbol).latest_price.to_s)
      total_amount = quantity * price
      stock = Stock.create_or_update_stock(symbol, current_user, initialize_iex_client)

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

    def sell
      symbol, quantity, action = params.values_at(:symbol, :quantity, :action)
      quantity = quantity.to_i
      price = BigDecimal(initialize_iex_client.quote(symbol).latest_price.to_s)
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

    def initialize_iex_client
       @iex_client ||= IEX::Api::Client.new
    end

    def get_quotes(symbols)
       symbols.map { |symbol| initialize_iex_client.quote(symbol) }
    end

    def get_logos(symbols)
       symbols.map { |symbol| initialize_iex_client.logo(symbol)&.url }.compact
    end

    def check_approval_status
      unless current_user.approved?
        flash[:alert] = 'You are not approved to perform this action.'
        redirect_to traders_path
      end
    end
  end
