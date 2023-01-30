class Admin::HomesController < Admin::Base
  def top
    @employees = Employee.order(id: :desc)
    @employees = @employees.page(params[:page]).per(10)
  end
end
