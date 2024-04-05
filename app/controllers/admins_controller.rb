class AdminsController < ApplicationController
    def index
        @users = User.all
    end

    def grant_admin
        current_user.update_attribute(:admin, true)
        redirect_to admins_path, notice: "You have been granted admin status."
      end

end
