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

    if Public::Authenticator.new(employee).authenticate(@form.password)
      session[:employee_id] = employee.id
      flash.notice = "ログインしました。"
      redirect_to :root
    else
      flash.now.alert = "従業員番号またはパスワードが正しくありません。"
      render action: "new"
    end
  end

  def destroy
    session.delete(:employee_id)
    flash.notice = "ログアウトしました。"
    redirect_to new_sessions_path
  end
end
