class Public::Base < ApplicationController
  layout 'public'

  private
  
  def current_employee
    if session[:employee_id]
      @current_employee ||= Employee.find_by(id: session[:employee_id])
    end
  end

  helper_method :current_employee
end
