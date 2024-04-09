module Admin
    class TradersController < ApplicationController

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

        def pendings
            @pending_traders = User.where(admin: false, approved: false)
        end

        def approve
            # @pending_trader = User.where(approved: false).find(params[:id])
            # @pending_trader.approved = true
            # @pending_trader.save

            @pending_trader = User.find(params[:id])
            @pending_trader.toggle!(:approved)

            #only triggers if user approved converted to true
            if @pending_trader.approved?
                TraderMailer.with(user: @pending_trader).approved_email.deliver_now
            end
            
            redirect_to admin_traders_path
        end
    end 
end
