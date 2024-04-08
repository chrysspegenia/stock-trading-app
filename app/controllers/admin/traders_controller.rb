module Admin
    class TradersController < ApplicationController
        def index
            @traders = User.all
        end

        def grant_admin
            current_user.update_attribute(:admin, true)
            redirect_to admin_traders_path, notice: "You have been granted admin status."
        end
    end 
end
