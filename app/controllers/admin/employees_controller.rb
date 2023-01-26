class Admin::EmployeesController < Admin::Base
  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      flash.notice = "従業員アカウントを新規登録しました。"
      redirect_to admin_employee_path(@employee.id)
    else
      flash.now.alert = "入力項目に誤りがあります。再度登録を行ってください。"
      render action: "new"
    end
  end

  def show
    @employee = Employee.find(params[:id])
    @salary = Salary.find_by(employee_number: @employee.employee_number, created_at: Time.current.all_month)
    @leave_requests = LeaveRequest.where(permitted: true).where(employee_canceled: false)
  end

  def edit
    @employee = Employee.find(params[:id])
  end

  def update
    @employee = Employee.find(params[:id])
    if @employee.update(employee_params)
      flash.notice = "登録情報を更新しました。"
      redirect_to admin_employee_path
    else
      flash.now.alert = "入力項目に誤りがあります。再度更新を行ってください。"
      render action: "edit"
    end
  end

  def confirm #アカウント削除専用確認画面
    @employee = Employee.find(params[:id])
  end

  def destroy #従業員アカウントの削除
    @employee = Employee.find(params[:id])
    @admin = current_admin

      # 「管理者パスワードが一致」かつ「チェックボックスが入力されている」場合のみ、削除が可能になる
    if ( params[:employee][:password] == @admin.password ) && ( params[:employee][:confirm] == true )
      @employee.destroy
      flash.notice = "該当従業員データを削除しました。"
      redirect_to admin_root_path
    else
      flash.now.alert = "入力項目に誤りがあります。再度手続きを行ってください。"
      render action: "confirm"
    end
  end

  private #ストロングパラメータ
  def employee_params
    params.require(:employee).permit(
      :employee_number, :last_name, :first_name, :last_name_kana,
      :first_name_kana, :password, :address, :telephone_number, :email,
      :number_of_paid_leave, :start_date, :end_date, :suspended
    )
  end
end