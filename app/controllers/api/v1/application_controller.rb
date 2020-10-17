class Api::V1::ApplicationController < ApplicationController
  def check_token_and_key
    unless params[:api_authenticate_token] == ENV["API_AUTHENTICATE_TOKEN"] && params[:api_authenticate_key] == ENV["API_AUTHENTICATE_KEY"]
      flash[:notice] = "認証トークンか認証キーが不正です"
      redirect_to root_url
    end
  end
end
