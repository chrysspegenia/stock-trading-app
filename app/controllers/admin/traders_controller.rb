module Admin
    class TradersController < ApplicationController
        before_action :authorize_admin
        before_action :set_trader, only: [:show, :edit, :update, :balance_new, :balance]

        layout "admin_dashboard"
        # Get /admin/traders
        def index
            @traders = User.all.where(admin: false, approved: true)
            @pending_traders = User.where(admin: false, approved: false)
        end

        # GET /admin/traders/pendings
        def pendings
            @pending_traders = User.where(admin: false, approved: false)
        end

        #POST /admin/traders/:id/approve
        def approve
            @pending_trader = User.find(params[:id])
            @pending_trader.toggle!(:approved)

            #only triggers if user approved converted to true
            if @pending_trader.approved?
                TraderMailer.with(user: @pending_trader).approved_email.deliver_later
            end

            redirect_to admin_traders_path
        end

        # GET /admin/traders/:id/balance_new
        def balance_new
        end

        # POST /admin/traders/:id/balance
        def balance
            @trader.update(balance: (params[:initial_balance]))
            redirect_to admin_traders_path
        end

        # GET /admin/traders/transaction
        def transactions
            @transactions = Transaction.all.order(id: :desc)
        end

        #GET /admin/traders/:id
        def show
            @transactions = Transaction.where(user_id: @trader.id).order(id: :desc)
        end

        #GET /admin/traders/new
        def new
            @trader = User.new
        end

        #GET /admin/traders/:id/edit
        def edit
        end

        #POST /admin/traders
        def create
            @trader = User.new(trader_params)
            @trader.skip_confirmation!
            @trader.approved = true

            if @trader.save
                redirect_to admin_trader_path(@trader), notice: "Trader was successfully created."
                TraderMailer.with(user: @trader).approved_email.deliver_later
            else
                render :new, status: :unprocessable_entity
            end
        end

        #PATCH /admin/traders/:id
        def update
            if @trader.update(trader_params)
                redirect_to admin_trader_path(@trader), notice: "Trader was successfully updated."
            else
                render :edit, status: :unprocessable_entity
            end
        end

        # #temporaray method to grant admin status
        # def grant_admin
        #     current_user.update_attribute(:admin, true)
        #     redirect_to admin_traders_path, notice: "You have been granted admin status."
        # end

        private

        def authorize_admin
            redirect_to traders_path unless current_user.admin?
        end

        def set_trader
            @trader = User.find(params[:id])
        end

        def trader_params
            params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :approved)
        end
    end
end
