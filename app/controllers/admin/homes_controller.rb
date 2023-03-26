class Admin::HomesController < Admin::Base
  def top
    @search_form = Admin::EmployeeSearchForm.new
    @employees = Employee.order(employee_number: :asc)
    @employees = @employees.page(params[:page]).per(10)
  end
end
