class Public::HomesController < Public::Base
  def top
    @employee = current_employee
    @leave_requests = LeaveRequest.where(employee_number: current_employee)
  end
end
