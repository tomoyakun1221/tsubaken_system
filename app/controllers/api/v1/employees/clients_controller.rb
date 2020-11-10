class Api::V1::Employees::ClientsController < Api::V1::ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_token_and_key_to_api
  before_action :set_client, only: [:update, :self_update, :destroy]

  def create
    client = Client.new(client_params.merge(password: "password", password_confirmation: "password"))
    if client.save
      render json: client, serializer: ClientSerializer
    else
      render json: { status: "false", message: client.errors.full_messages }
    end
  end

  def update
    if @client.update(client_params)
      render json: @client, serializer: ClientSerializer
    else
      render json: { status: "false", message: @client.errors.full_messages }
    end
  end
  
  def self_update
    if @client.update(client_params)
      render json: @client, serializer: ClientSerializer
    else
      render json: { status: "false", message: @client.errors.full_messages }
    end
  end

  def destroy
    if @client.destroy
      render json: @client, serializer: ClientSerializer
    else
      render json: { status: "false", message: @client.errors.full_messages }
    end
  end

  private
    def client_params
      params.permit(:name, :gender, :login_id, :phone_1, :phone_2, :email, :birthed_on, :zipcode, :address)
    end

    def set_client
      @client = Client.find(params[:id])
    end
end
