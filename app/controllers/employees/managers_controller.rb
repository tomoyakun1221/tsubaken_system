class Employees::ManagersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_manager, only: [:show, :edit, :update, :destroy]
  before_action :set_departments, only: [:new, :edit, :show]

  def new
    @manager = Manager.new
  end

  def create
    @manager = Manager.new(manager_params.merge(password: "password", password_confirmation: "password"))
    if @manager.save
      flash[:success] = "Managerを作成しました"
      redirect_to employees_manager_url(@manager)
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def index
    @enrolled_managers = Manager.enrolled
    @retired_managers = Manager.retired
  end

  def show
  end

  def edit
  end

  def update
    if @manager.update(manager_params)
      flash[:success] = "Manager情報を更新しました。"
      redirect_to employees_manager_url(@manager)
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @manager.destroy ? flash[:success] = "Managerを削除しました。" : flash[:alert] = "Managerを削除できませんでした。"
    redirect_to employees_managers_url
  end

  private
    def manager_params
      params.require(:manager).permit(:name, :login_id, :phone, :email, :birthed_on, :zipcode, :address, :department_id, :joined_on, :resigned_on)
    end

    def set_manager
      @manager = Manager.find(params[:id])
    end
    
    def set_departments
      @departments = Department.all
    end
end
