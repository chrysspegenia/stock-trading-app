class CustomFailure < Devise::FailureApp

    #Redirects back to root path upon invalid sign in
    def redirect_url
      root_path
    end
 
    def respond
      if http_auth?
        http_auth
      else
        redirect
      end
    end
  end