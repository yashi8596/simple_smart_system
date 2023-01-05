class Public::SessionsController < Public::Base
  def new
    if current_employee
      redirect_to :root
    else
      @form = Public::LoginForm.new
      render action: "new"
    end
  end

  def create
    @form = Public::LoginForm.new(params[:public_login_form])
    if @form.employee_number.present?
      employee = Employee.find_by("employee_number = ?", @form.employee_number.downcase)
    end

    if employee
      session[:employee_id] = employee.id
      redirect_to :root
    else
      render action: "new"
    end
  end

  def destroy
  end
end
