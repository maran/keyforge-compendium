class ApiKeysController < ApplicationController
  before_action :authenticate_user!

  def index
    @api_keys = current_user.api_keys
  end

  def new
    @api_key = current_user.api_keys.build
  end

  def create
    @api_key = current_user.api_keys.build
    @api_key.name = params[:api_key][:name]
    if @api_key.save
      redirect_to api_keys_path
    else
      render :new
    end
  end
end
