class Employees::Settings::TasksController < ApplicationController
  before_action :authenticate_admin_or_manager!
  before_action :set_employees_settings_tasks, only: :index
  before_action :set_task, only: [:edit, :update, :destroy]

  def index
    @default_tasks = Task.are_default
  end

  def new
    @default_task = Task.new
  end

  def create
    sort_order = Task.are_default.length
    @default_task = Task.new(default_task_params.merge(status: 0, sort_order: sort_order))
    if @default_task.save
      @default_task.update(default_task_id: @default_task.id)
      flash[:success] = "デフォルトタスクを作成しました。"
      redirect_to employees_settings_tasks_url
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def edit
  end

  def update
    if @default_task.update(default_task_params)
      flash[:success] = "デフォルトタスクを更新しました。"
      redirect_to employees_settings_tasks_url
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @default_task.destroy ? flash[:success] = "デフォルトタスクを削除しました。" : flash[:alert] = "デフォルトタスクを削除できませんでした。"
    Task.reload_sort_order(Task.are_default)
    redirect_to employees_settings_tasks_url
  end

  private
    def set_employees_settings_tasks
      @employees_settings_tasks = "employees_settings_tasks"
    end

    def default_task_params
      params.require(:task).permit(:title, :content)
    end

    def set_task
      @default_task= Task.find(params[:id])
    end
end
