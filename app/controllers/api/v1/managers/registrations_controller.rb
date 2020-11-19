class Api::V1::Managers::RegistrationsController < Api::V1::ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_token_and_key_to_api

  def update_self
    @manager = Manager.find(params[:id])
    if @manager.update(manager_params)
      render json: @manager, serializer: RegistrationSerializer
    else
      render json: { status: "false", message: @manager.errors.full_messages }
    end
  end

  private
    def manager_params
      params.permit(:name, :login_id, :phone, :email, :birthed_on, :zip_code, :address, :department_id, :joined_on, :resigned_on)
    end
end