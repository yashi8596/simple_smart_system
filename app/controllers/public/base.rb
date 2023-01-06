class Public::Base < ApplicationController
  before_action :login #ログイン前のアクセス制御
  layout 'public'

  private

  def login
    unless current_employee
      redirect_to new_sessions_path
    end
  end

  def current_employee
    if session[:employee_id]
      @current_employee ||= Employee.find_by(id: session[:employee_id])
    end
  end

  helper_method :current_employee
end
