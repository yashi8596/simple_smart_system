class Public::SalariesController < Public::Base
  def show
    @salary = Salary.find_by(employee_number: current_employee.id, id: params[:id])
    unless @salary.permit?
      flash.alert = "選択されたリンクは閲覧することができません。こちらは#{@salary.set_transfer.ago(10.days).strftime("%Y年%m月%d日")}から閲覧可能となっています。"
      render action: "index"
    end
  end

  def index
    @salaries = Salary.where(employee_number: current_employee.id)
    @salaries = @salaries.order(created_at: :desc)
    @salaries = @salaries.page(params[:page]).per(10)
  end
end
