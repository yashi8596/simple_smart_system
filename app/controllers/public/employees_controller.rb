class Public::EmployeesController < Public::Base
  def show
    @employee = current_employee
  end

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

  private
  def employee_params
    params.require(:employee).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :email)
  end
end
