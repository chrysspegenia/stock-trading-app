class Users::SessionsController < Devise::SessionsController
    protected

    def after_sign_in_path_for(resource)
        if resource.admin?
            admin_traders_path
        else
            traders_path
        end
    end
end
