class Public::EmployeesController < Public::Base
  def edit
    @employee = current_employee
  end

  def update
    @employee = current_employee
    if @employee.update(employee_params)
      flash.notice = "従業員情報を更新しました。"
      redirect_to root_path
    else
      flash.now.alert = "お手数ですが、操作をやり直して下さい。"
      render action: "edit"
    end
  end

  def paid_leave_update
    @employee = current_employee
    #有給付与前にgrantedを0に戻す（2回目以降の有給付与で必要なため）
    if current_employee.granted_reset
      @current_employee.granted = false
    end

    #start_dateから1年6ヶ月後(以後1年ごと)に一定の値をnumber_of_paid_leaveに加算する
    if current_employee.add_granted?
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
    end
    
    if @current_employee.update(grant_params)
      flash.notice = "有給残日数を更新しました。"
      redirect_to root_path
    else
      flash.now.alert = "所定の条件を満たしていないため、有給残日数を付与することができません。"
      render action: "homes/top"
    end
  end

  private
  def employee_params
    params.require(:employee).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :email)
  end
  
  def grant_params
    params.require(:employee).permit(:number_of_paid_leave, :granted, :prev_grant_date, :next_grant_date)
  end
end
