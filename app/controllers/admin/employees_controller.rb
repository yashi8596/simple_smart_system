class Admin::EmployeesController < Admin::Base
  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)
    @employee.next_grant_date = @employee.start_date.since(6.month)

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
    @salary = Salary.find_by(employee_id: @employee.id, created_at: Time.current.all_month)
  end

  def index
    @search_form = Admin::EmployeeSearchForm.new(search_params)
    @employees = @search_form.search.page(params[:page]).per(10)
  end

  def edit
    @employee = Employee.find(params[:id])
  end

  def update
    @employee = Employee.find(params[:id])
    emp_was = @employee.id_in_database

    begin

      if @employee.update!(employee_params)

        if @employee.saved_change_to_prev_grant_date?
          @employee.update_attribute(:next_grant_date, @employee.prev_grant_date >> 12)
        end

        if @employee.saved_change_to_employee_number?
          #従業員番号が変更された場合、関連付けられているレコードを一括更新する
          LeaveRequest.where(employee_id: emp_was).update_all(employee_id: @employee.id)
          Salary.where(employee_id: emp_was).update_all(employee_id: @employee.id)
        end

        flash.notice = "登録情報を更新しました。"
        redirect_to admin_employee_path(@employee.id)
      end

    rescue ActiveRecord::RecordInvalid => e

      @errors = e.record.errors.full_messages

    flash.now.alert = "入力項目に誤りがあります。再度更新を行ってください。"
    render action: "edit"
    end
  end

  def confirm #アカウント削除専用確認画面
    @employee = Employee.find(params[:id])
    unless @employee.end_date? && @employee.suspended?
      flash.now.alert = "従業員の「退職日が未定」、もしくは「停止ステータスが無効」になっています。"
      render action: "edit"
    end
  end

  def destroy #従業員アカウントの削除
    employee = Employee.find(params[:id])

    employee.destroy
    flash.notice = "該当従業員データを削除しました。"
    redirect_to admin_root_path
  end

  private #ストロングパラメータ
  def employee_params
    params.require(:employee).permit(
      :employee_number, :last_name, :first_name, :last_name_kana,
      :first_name_kana, :password, :address, :telephone_number, :email,
      :number_of_paid_leave, :start_date, :end_date, :suspended,
      :next_grant_date, :granted, :prev_grant_date
    )
  end

  def search_params
    params[:search]&.try(:permit, [:last_name_kana, :first_name_kana, :employee_number])
  end
end
