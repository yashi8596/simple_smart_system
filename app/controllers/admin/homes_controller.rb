class Admin::HomesController < Admin::Base
  def top
    @employees = Employee.order(employee_number: :desc)
    @employees = @employees.page(params[:page]).per(10)
  end
end
