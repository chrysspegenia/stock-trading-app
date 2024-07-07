class Users::CustomLoginRegisterPageController < ApplicationController
    skip_before_action :authenticate_user!
    before_action :set_devise_resource

    def index
    end

    def set_devise_resource
        @resource = User.new
        @resource_name = :user
        @devise_mapping = Devise.mappings[:user]
    end
end