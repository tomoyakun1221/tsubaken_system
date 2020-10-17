class Managers::AttendancesController < ApplicationController
  before_action :authenticate_manager!
  before_action :set_one_month
  before_action ->{ create_month_attendances(current_manager) }
  before_action ->{ set_today_attendance(current_manager) }
  
  def index
  end

  def update
    if @attendance.started_at.blank? && @attendance.finished_at.blank? && @attendance.update_attributes(started_at: Time.now)
      flash[:success] = "出勤しました"
    elsif @attendance.started_at.present? && @attendance.finished_at.blank? && @attendance.update_attributes(finished_at: Time.now)
      flash[:success] = "退勤しました"
    else
      flash[:success] = "エラーが発生しました"
    end
    redirect_to managers_attendances_url
  end
end
