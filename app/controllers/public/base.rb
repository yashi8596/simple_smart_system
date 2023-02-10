class Public::Base < ApplicationController
  before_action :login #ログイン前のアクセス制御
  before_action :check_account
  before_action :check_timeout
  before_action :check_paid_leave
  layout 'public'

  private

  def login
    unless current_employee
      redirect_to new_session_path
    end
  end

  def check_paid_leave
    if current_employee && current_employee.add_10_paid_leave
      current_employee.number_of_paid_leave = 10
    end
  end

  def check_account #従業員の強制ログアウト機能
    if current_employee && !current_employee.active?
      session.delete(:employee_number)
      flash.alert = "アカウントが無効になりました。"
      redirect_to new_session_path
    end
  end

  #セッションタイムアウトの設定時間
  TIMEOUT = 60.minutes

  def check_timeout #従業員のセッションタイムアウト機能
    if current_employee
      if session[:last_access_time] >= TIMEOUT.ago
        session[:last_access_time] = Time.current
      else
        session.delete(:employee_number)
        flash.alert = "セッションタイムアウトになりました。再度ログインして下さい。"
        redirect_to new_session_path
      end
    end
  end

  def current_employee #従業員のセッション機能
    if session[:employee_number]
      @current_employee ||= Employee.find_by(employee_number: session[:employee_number])
    end
  end

  helper_method :current_employee
end
