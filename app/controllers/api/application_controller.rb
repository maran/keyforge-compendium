class Api::ApplicationController < ApplicationController
  before_action :authenticate
  def authenticate
    key = authenticate_with_http_basic { |u, p| ApiKey.find_by(key: u, secret: p) }
    if key.present?
      ApiKey.increment_counter(:requests, key.id)
    elsif Rails.env == 'development'
      Rails.logger.info("Allowing development access")
    else
      render json: {error: 401, message: "Please request an API key on the website."}, status: 401 and return
    end
  end
end
