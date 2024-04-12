class AdminsController < ApplicationController
    def index
        @users = User.all
        @pending_users = User.where(approved: false)
        @approved_users = User.where(approved: true)
    end

    def show
        @user = User.find(params[:format])
    end

    def grant_admin
        current_user.update_attribute(:admin, true)
        redirect_to admins_path, notice: "You have been granted admin status."
    end

    def approve
        user = User.find(params[:format])
        user.approved = true
        if user.save
          redirect_to admins_path, notice: "#{user.email} has been approved."
        else
          redirect_to admins_path, alert: "Failed to approve #{user.email}."
        end
    end
end
