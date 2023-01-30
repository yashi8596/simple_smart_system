class Admin::Base < ApplicationController
  before_action :authorize #管理者以外のアクセス制御
  before_action :check_account
  before_action :check_timeout
  before_action :check_lr_destroy
  layout 'admin'

  private
  def current_admin
    if session[:admin_id]
      @current_admin ||= Admin.find_by(id: session[:admin_id])
    end
  end

  helper_method :current_admin

  def authorize
    unless current_admin
      flash.alert = "管理者としてログインしてください。"
      redirect_to new_admin_session_path
    end
  end

  def check_account
    if current_admin && current_admin.suspended?
      session.delete(:admin_id)
      flash.alert = "アカウントが無効になりました。"
      redirect_to new_admin_session_path
    end
  end

  #セッションタイムアウトの設定時間
  TIMEOUT = 60.minutes

  def check_timeout
    if current_admin
      if session[:admin_last_access_time] >= TIMEOUT.ago
        session[:admin_last_access_time] = Time.current
      else
        session.delete(:admin_id)
        flash.alert = "セッションタイムアウトになりました。再度ログインして下さい。"
        redirect_to new_admin_session_path
      end
    end
  end

  #有給の自動削除
  def check_lr_destroy
    @leave_requests = LeaveRequest.all
    if @leave_requests
      @leave_requests.each do |lr|
        if lr.auto_destroy
          lr.destroy
        end
      end
    end
  end
end
