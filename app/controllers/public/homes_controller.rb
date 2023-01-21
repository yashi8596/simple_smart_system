class Public::HomesController < Public::Base
  def top
    @employee = current_employee
    @events = EmployeeEvent.all
    @leave_requests = LeaveRequest.where(employee_number: current_employee).where(permitted: [nil, false])
  end
end
