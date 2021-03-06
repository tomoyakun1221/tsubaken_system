class Employees::TasksController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_matter
  before_action :set_task, only: [:update, :destroy]

  def move
    new_status = convert_to_status_num(params[:status]).to_i
    @default_tasks = Task.are_default
    # 移動先がデフォルトタスクでない場合のみ処理
    unless new_status == 0
      task = Task.find(params[:task])
      sort_order = params[:item_index].to_i
      # 同ステータス内で上に移動時
      if task.status_before_type_cast == new_status && task.sort_order < sort_order
        # 対象タスクより、優先順位が上の全タスクのsort_orderを-1
        Task.decrement_sort_order(@matter, new_status, sort_order)
        task.update(moved_on: Time.current, sort_order: sort_order)
      # ステータス移動、又は下に移動時
      else
        # 対象タスクより、優先順位が下の全タスクのsort_orderを+1
        Task.increment_sort_order(@matter, new_status, sort_order)
        if task.default?
          # デフォルトタスクからコピー
          @matter.tasks.create(title: task.title, content: task.content, status: new_status, default_task_id: task.id, sort_order: sort_order)
          Task.count_default_tasks(@default_tasks)
        else
          # タスク移動
          task.update(status: new_status, moved_on: Time.current, before_status: task.status, sort_order: sort_order)
        end
      end
    end
    set_classified_tasks(@matter)
    respond_to do |format|
      format.js
    end
  end
  
  def create
    # 作成前に進行中タスクのsort_orderを更新
    relevant_tasks = @matter.tasks.are_relevant
    Task.reload_sort_order(relevant_tasks)
    # 追加するタスクのsort_orderを定義
    sort_order = relevant_tasks.length
    title = params[:title]
    @matter.tasks.create(title: title, status: 1, sort_order: sort_order)
    set_classified_tasks(@matter)
    respond_to do |format|
      format.js
    end
  end
  
  def update
    if @task.update(task_params)
      set_classified_tasks(@matter)
      respond_to do |format|
        format.js
      end
    end
  end
  
  def destroy
    if @task.destroy
      flash[:danger] = "タスクを削除しました。"
      set_classified_tasks(@matter)
      respond_to do |format|
        format.js
      end
    end
  end
  
  private

    def set_matter
      @matter = Matter.find(params[:matter_id])
    end

    def set_task
      @task = Task.find(params[:id])
    end

    # paramsで送られてきたstatusをenumの数値に変換
    def convert_to_status_num(status)
      case status
      when "default-tasks"
        0
      when "relevant-tasks"
        1
      when "ongoing-tasks"
        2
      when "finished-tasks"
        3
      end
    end
    
    def task_params
      params.require(:task).permit(:title, :content, :manager_id, :staff_id, :external_staff_id)
    end
end
