class Admin::Base < ApplicationController
  before_action :authorize #管理者以外のアクセス制御
  layout 'admin'

  private
  def authorize
    unless current_admin
      flash.alert = "管理者としてログインしてください。"
      redirect_to new_admin_sessions_path
    end
  end

  def current_admin
    if session[:admin_id]
      @current_admin ||= Admin.find_by(id: session[:admin_id])
    end
  end

  helper_method :current_admin

end
