class Public::SalariesController < Public::Base
  def show
    @salary = Salary.find_by(employee_number: current_employee.id, id: params[:id])
  end

  def index
    @salaries = Salary.where(employee_number: current_employee.id)
  end
end
