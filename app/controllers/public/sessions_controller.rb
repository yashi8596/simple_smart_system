class Public::SessionsController < Public::Base
  skip_before_action :login

  def new
    if current_employee
      redirect_to :root
    else
      @form = Public::LoginForm.new
      render action: "new"
    end
  end

  def create
    @form = Public::LoginForm.new(login_form_params)
    if @form.employee_number.present?
      employee = Employee.find_by("employee_number = ?", @form.employee_number.downcase)
    end

    if Public::Authenticator.new(employee).authenticate(@form.password)
      if employee.suspended?
        # suspendedがtrueの場合に表示されるフラッシュメッセージ
        flash.now.alert = "アカウントが停止されています。"
        render action: "new"
      else
        session[:employee_id] = employee.id
        flash.notice = "ログインしました。"
        redirect_to :root
      end
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

  private
  def login_form_params
    params.require(:public_login_form).permit(:employee_number, :password)
  end
end
