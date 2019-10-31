class ApplicationController < ActionController::Base
  before_action :redirect_subdomain
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:favourites_public, :username, :email, :password, :password_confirmation])
  end



  def redirect_subdomain
    if request.host == 'www.keyforge-compendium.com'
      redirect_to 'https://keyforge-compendium.com' + request.fullpath, :status => 301
    elsif request.host == 'keyforge.herokuapp.com'
      redirect_to 'https://keyforge-compendium.com' + request.fullpath, :status => 301
    end
  end
end
