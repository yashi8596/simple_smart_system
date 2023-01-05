class Admin::SessionsController < Admin::Base
  def new
    if current_admin
      redirect_to :admin_root
    else
      @form = Admin::LoginForm.new
      render action: "new"
    end
  end

  def create
    @form = Admin::LoginForm.new(params[:admin_login_form])
    if @form.email.present?
      admin = Admin.find_by("LOWER(email) = ?", @form.email.downcase)
    end

    if Admin::Authenticator.new(admin).authenticate(@form.password)
      if admin.suspended?
         # suspendedがtrueの場合に表示されるフラッシュメッセージ
        flash.now.alert = "アカウントが停止されています。"
        render action: "new"
      else
        session[:admin_id] = admin.id
        flash.notice = "ログインしました。"
        redirect_to :admin_root
      end
    else
      flash.now.alert = "メールアドレスまたはパスワードが正しくありません。"
      render action: "new"
    end
  end

  def destroy
    session.delete(:admin_id)
    flash.notice = "ログアウトしました。"
    redirect_to new_admin_sessions_path
  end
end
