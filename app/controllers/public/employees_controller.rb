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
    #有給付与前にgrantedをfalseに戻す（2回目以降の有給付与で必要なため）
    if @employee.granted_reset
      @employee.granted = false
    end


    if @employee.add_granted?

      @employee.number_of_paid_leave = @employee.calc_paid_leave　#start_dateから1年6ヶ月後(以後1年ごと)に一定の値をnumber_of_paid_leaveに加算する
      @employee.prev_grant_date = @employee.next_grant_date #next_grant_dateをprev_grant_dateに代入
      @employee.next_grant_date = @employee.next_grant_date.since(1.year) #next_grant_dateに既定値の1年後の日付を代入
      @employee.granted = true #有給付与後にgrantedをtrueにする(期間中一度だけしか更新できないようにするため)

      if @employee.update(pl_params)
        flash.notice = "有給残日数を更新しました。"
        redirect_to root_path and return
      end
    end

    flash.alert = "「現在日時が次回有給付与日時、もしくはそれ以降になっていない」ため、有休残日数を付与することができません。"
    redirect_to root_path and return
  end

  private
  def employee_params
    params.require(:employee).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :email)
  end

  def pl_params
    params.permit(:granted, :number_of_paid_leave, :prev_grant_date, :next_grant_date)
  end
end
