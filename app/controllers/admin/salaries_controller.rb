class Admin::SalariesController < Admin::Base
  def new
    @salary = Salary.new
  end

  def create
    @salary = Salary.new(salary_params)
    salary = Salary.find_by(employee_id: @salary.employee_id, created_at: Time.current.all_month)

    unless salary
      # 作成された給与明細が重複していないかどうか判定
      if @salary.save
        flash.notice = "給与明細の登録が完了しました。"
        redirect_to admin_salary_path(@salary.id)
      else
        flash.now.alert = "入力に誤りがあります。再度登録を行ってください。"
      end
    else
      flash.now.alert = "選択した従業員の今月の給与明細は既に作成されています。"
    end
    render action: "new"
  end

  def index
    #今月作成したもののみ表示
    @salaries = Salary.where(created_at: Time.current.all_month)
  end

  def show
    @salary = Salary.find(params[:id])
    @employee = Employee.find_by(employee_number: @salary.employee_id)
  end

  def edit
    @salary = Salary.find(params[:id])
  end

  def update
    @salary = Salary.find(params[:id])
    if @salary.update(salary_params)
      flash.notice = "給与明細の更新が完了しました。"
      redirect_to admin_salary_path(@salary.id)
    else
      flash.now.alert = "入力に誤りがあります。再度登録を行ってください。"
      render action: "edit"
    end
  end

  private
  def salary_params
    params.require(:salary).permit(
      :employee_id, :total_workday, :used_paid_leave, :absent,
      :wage, :total_hour, :total_minute, :extra_hour, :extra_minute,
      :midnight_hour, :midnight_minute,
    )
  end
end