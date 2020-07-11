class Staff::EventsController < ApplicationController
  # before_action :not_current_staff_return_login!
  before_action :staff_event_title
  
  def index
    @events = Event.where(matter_id: current_staff.matters).where("event_type = ? or event_type = ?","C","D")
    @staff_events = StaffEvent.where(staff_id: current_staff.id)
  end
end
