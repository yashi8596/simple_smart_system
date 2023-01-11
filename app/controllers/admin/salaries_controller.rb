class Admin::SalariesController < Admin::Base
  def new
    @salary = Salary.new
  end

  def create
    @salary = Salary.new(salary_params)
    if @salary.save
      flash.notice = "給与明細の登録が完了しました。"
      redirect_to admin_salary_path(@salary.id)
    else
      flash.now.alert = "入力に誤りがあります。再度登録を行ってください。"
      render action: "new"
    end
  end

  #def index
    #salaries = Salary.where("created_at > ?", Date.current.beginning_of_month).where("created_at < ?", Date.current.end_of_month)
    #salaries = Salary.where(created_at: Date.current.all_month)
   # @employees = Employee.where.missing(:salaries)
  #end

  def show
    @salary = Salary.find(params[:id])
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
      :employee_number, :wage, :total_hour, :extra_hour, :midnight_hour,
      :total_minute, :extra_minute, :midnight_minute,
      :total_workday, :used_paid_leave, :absent
    )
  end
end