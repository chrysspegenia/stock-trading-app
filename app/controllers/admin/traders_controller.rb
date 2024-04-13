module Admin
    class TradersController < ApplicationController
        before_action :set_trader, only: [:show, :edit, :update]

        # Get /admin/traders
        #loads both approved and non-approved traders
        def index
            @traders = User.all.where(admin: false, approved: true)
            @pending_traders = User.where(admin: false, approved: false)
        end

        #temporaray method to grant admin status
        def grant_admin
            current_user.update_attribute(:admin, true)
            redirect_to admin_traders_path, notice: "You have been granted admin status."
        end

        # GET /admin/traders/pendings
        def pendings
            @pending_traders = User.where(admin: false, approved: false)
        end

        #POST /admin/traders/:id/approve
        def approve
            # @pending_trader = User.where(approved: false).find(params[:id])
            # @pending_trader.approved = true
            # @pending_trader.save

            @pending_trader = User.find(params[:id])
            @pending_trader.toggle!(:approved)

            #only triggers if user approved converted to true
            if @pending_trader.approved?
                TraderMailer.with(user: @pending_trader).approved_email.deliver_later
            end
            
            redirect_to admin_traders_path
        end

        #GET /admin/traders/:id
        def show 
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
            # @trader.skip_confirmation! #to include this need to add confirmed_at in table and confirmable in model
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

        private

        def set_trader
            @trader = User.find(params[:id])
        end

        def trader_params
            params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :approved)
        end
    end 
end
