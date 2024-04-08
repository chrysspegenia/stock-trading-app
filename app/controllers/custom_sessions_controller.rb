class CustomSessionsController < Devise::SessionsController
    def after_sign_in_path_for(resource)
        if resource.admin?
            admin_traders_path
        else
            traders_path
        end
    end

    # before_action :authenticate_admin!

    # def after_sign_in_path_for
    #   @admins = User.where(admin: true)
    # end
  
    # private
  
    # def authenticate_admin!
    #   redirect_to traders_path, alert: "You are not authorized to access this page." unless current_user.admin?
    # end
end
  