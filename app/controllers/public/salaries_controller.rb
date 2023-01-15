class Public::SalariesController < Public::Base
  def show
    @salary = Salary.find_by(employee_number: current_employee.employee_number, created_at: Time.current.all_month)
  end
end
