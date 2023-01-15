class Public::HomesController < Public::Base
  def top
    @employee = current_employee
    @events = EmployeeEvent.all
    @leave_requests = LeaveRequest.where(employee_number: @employee.employee_number, permitted: 0)
  end
end
