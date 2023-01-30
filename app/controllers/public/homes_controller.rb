class Public::HomesController < Public::Base
  def top
    @employee = current_employee
    @salary = Salary.find_by(employee_number: current_employee.id, created_at: Time.current.all_month)
    @leave_requests = LeaveRequest.where(employee_id: current_employee)
  end
end
