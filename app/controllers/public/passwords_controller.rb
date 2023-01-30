class Public::PasswordsController < Public::Base
  def edit
    @change_password_form = Public::ChangePasswordForm.new(object: current_employee)
  end

  def update
    @change_password_form = Public::ChangePasswordForm.new(employee_params)
    @change_password_form.object = current_employee
    if @change_password_form.save
      flash.notice = "パスワードを変更しました。"
      redirect_to root_path
    else
      flash.now.alert = "入力にに誤りがあります。"
      render action: "edit"
    end
  end

  private
  def employee_params
    params.require(:public_change_password_form).permit(:current_password, :new_password, :new_password_confirmation)
  end
end
