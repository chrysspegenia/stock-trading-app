class Users::RegistrationsController < Devise::RegistrationsController
    def create
        build_resource(sign_up_params)
    
        resource.save
        yield resource if block_given?
        if resource.persisted?
          if resource.active_for_authentication?
            set_flash_message! :notice, :signed_up
            sign_up(resource_name, resource)
            respond_with resource, location: after_sign_up_path_for(resource)
          else
            set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
            expire_data_after_sign_in!
            respond_with resource, location: after_inactive_sign_up_path_for(resource)
          end
        else
          clean_up_passwords resource
          set_minimum_password_length
        #   respond_with resource
          response_to_sign_up_failure(resource)
        end
      end

    private

    def after_sign_up_path_for(resource)
        root_path
    end

    def response_to_sign_up_failure(resource)
        if resource.email.blank? && resource.password.blank?
          flash[:alert] = "Please fill in the form"
        elsif User.exists?(email: resource.email)
          flash[:alert] = "Email already exists"
        end
        redirect_to root_path
      end      

end
  