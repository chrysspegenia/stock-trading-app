class TradersController < ApplicationController
    before_action :authorize_trader
    before_action :check_approval_status, only: [:buy_new, :buy, :sell_new, :sell, :balance, :balance_new]
    before_action :set_trader, only: [:index, :show, :edit, :update, :portfolio, :transaction, :buy_new, :sell_new, :balance_new]
    after_action :process_transaction, only: [:buy, :sell]
    helper_method :get_logo, :iex_client

    layout 'trader_dashboard'

    #GET /traders
    def index
        @quotes = iex_client.stock_market_list(:mostactive)
    end

    #GET traders/:symbol   ... :symbol value is the params[:id]
    def show
        @company = iex_client.company(params[:id])
        @logo = iex_client.logo(params[:id])
        @quote = iex_client.quote(params[:id])
        @chart_data = Stock.fetch_chart_data(iex_client, @company.symbol)
    end

    #GET /traders/:id/edit
    def edit
    end

    #PATCH traders/:id
    def update
      if @trader.update(trader_params)
          redirect_to admin_trader_path(@trader), notice: "Trader was successfully updated."
      else
          render :edit, status: :unprocessable_entity
      end
   end

    #GET traders/:id/portfolio
    def portfolio
      @stocks = current_user.stocks.where('shares > ?', 0)
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
      symbol, quantity, action, company_name = params.values_at(:symbol, :quantity, :action, :company_name)
      price = BigDecimal(iex_client.quote(symbol).latest_price.to_s)
      stock = Stock.create_or_update_stock(symbol, current_user, company_name)

      if (quantity.to_i * price) <= current_user.balance
        @transaction = Transaction.create_transaction(current_user, stock, quantity.to_i, price, action)
        @transaction.save!
      else
        flash[:alert] = 'Insufficient balance to make the purchase.'
        render :buy_new
      end
      redirect_to portfolio_trader_path
    end

    #GET /traders/:symbol/sell_new  ... :symbol value is the params[:id]
    def sell_new
      @quote = iex_client.quote(params[:id])
      @company = iex_client.company(params[:id])
    end

    #POST /traders/:id/sell
    def sell
      symbol, quantity, action, price = params.values_at(:symbol, :quantity, :action, :price)
      price = price.to_i
      stock = Stock.find_by(symbol: symbol, user_id: current_user.id)

      if stock && stock.shares >= quantity.to_i
        @transaction = Transaction.create_transaction(current_user, stock, quantity.to_i, price, action)
        @transaction.save!
      else
        flash[:alert] = 'Insufficient quantity of shares to sell.'
        render :sell_new
      end
      redirect_to portfolio_trader_path
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
      redirect_to portfolio_trader_path
    end

    private

    def authorize_trader
      redirect_to admin_traders_path unless !current_user.admin?
    end

    def set_trader
      @trader = current_user
    end

    def trader_params
      params.require(:user).permit(:first_name, :last_name, :email)
    end

    def iex_client
      @iex_client ||= IEX::Api::Client.new
    end

    def get_logo(symbol)
      iex_client.logo(symbol).url
    end

    def process_transaction
      if !(@transaction.nil?)
        User.update_balance(@transaction.user, @transaction.action, @transaction.price * @transaction.quantity.to_i)
        if @transaction.action == 'buy'
          Stock.update_portfolio(@transaction.stock, @transaction.quantity, @transaction.price)
        else
          Stock.update_portfolio(@transaction.stock, -@transaction.quantity, @transaction.price)
        end
      else
        flash[:alert] = 'Failed Transaction.'
      end
    end

    def check_approval_status
      unless current_user.approved?
        flash[:alert] = 'You are not approved to perform this action.'
        redirect_to traders_path
      end
    end
  end
