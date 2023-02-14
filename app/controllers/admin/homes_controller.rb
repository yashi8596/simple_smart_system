class Admin::HomesController < Admin::Base
  def top
    @employees = Employee.order(employee_number: :asc)
    @employees = @employees.page(params[:page]).per(10)
  end
end
