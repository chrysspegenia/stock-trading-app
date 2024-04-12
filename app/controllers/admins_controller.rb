class AdminsController < ApplicationController
    def index
        @users = User.all.where(admin: false)
        @pending_users = User.where(admin: false, approved: false)
        @approved_users = User.where(admin: false, approved: true)
    end


    def grant_admin
        current_user.update_attribute(:admin, true)
        redirect_to admins_path, notice: "You have been granted admin status."
    end

    def approve
        user = User.find(params[:format])
        user.approved = true
        if user.save!
          redirect_to admins_path, notice: "#{user.email} has been approved."
          UserMailer.approval_email(user).deliver_now
        else
          redirect_to admins_path, alert: "Failed to approve #{user.email}."
        end
    end
end
