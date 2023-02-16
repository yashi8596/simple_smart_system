class Public::Base < ApplicationController
  before_action :login #ログイン前のアクセス制御
  before_action :check_account
  before_action :check_timeout
  before_action :add_paid_leave
  layout 'public'

  private

  def login
    unless current_employee
      redirect_to new_session_path
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

  def add_paid_leave
    #有給付与前にgrantedを0に戻す（2回目以降の有給付与で必要なため）
    if current_employee && current_employee.granted_reset
      @current_employee.granted = false
      @current_employee.update_attribute(:granted, @current_employee.granted)
    end

    #start_dateから1年6ヶ月後(以後1年ごと)に一定の値をnumber_of_paid_leaveに加算する
    if current_employee && current_employee.granted?
      case next_grant_date
      when start_date.since(6.month) then
      #6ヶ月後の有給付与
        @current_employee.number_of_paid_leave = 10
      when start_date.since(18.month) then
      #1年6ヶ月後の有給付与
        @current_employee.number_of_paid_leave = @current_employee.number_of_paid_leave.to_i + 11
      when start_date.since(30.month) then
      #2年6ヶ月後の有給付与
        @current_employee.number_of_paid_leave = @current_employee.number_of_paid_leave.to_i + 12
      when start_date.since(42.month) then
      #3年6ヶ月後の有給付与
        @current_employee.number_of_paid_leave = @current_employee.number_of_paid_leave.to_i + 14
      when start_date.since(54.month) then
      #4年6ヶ月後の有給付与
        @current_employee.number_of_paid_leave = @current_employee.number_of_paid_leave.to_i + 16
      when start_date.since(66.month) then
      #5年6ヶ月後の有給付与
        @current_employee.number_of_paid_leave = @current_employee.number_of_paid_leave.to_i + 18
      when start_date.since(78.month)..nil then
      #6年6ヶ月後の有給付与
        @current_employee.number_of_paid_leave = @current_employee.number_of_paid_leave.to_i + 20
      end
      @current_employee.granted = true #before_actionで実行するので、ログインする度に有給が付与されないようにする
      @current_employee.prev_grant_date = next_grant_date #next_grant_dateをprev_grant_dateに代入
      @current_employee.next_grant_date = next_grant_date.since(1.year) #next_grant_dateに既定値の1年後の日付を代入
      @current_employee.update(update_params)
    end
  end

  def current_employee #従業員のセッション機能
    if session[:employee_number]
      @current_employee ||= Employee.find_by(employee_number: session[:employee_number])
    end
  end

  helper_method :current_employee

  private
  def update_params
    params.require(:employee).permit(:number_of_paid_leave, :granted, :prev_grant_date, :next_grant_date)
  end
end
