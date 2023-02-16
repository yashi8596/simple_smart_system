class Admin::SessionsController < Admin::Base
  skip_before_action :authorize #管理者以外のアクセス制御

  def new
    if current_admin
      redirect_to :admin_root
    else
      @form = Admin::LoginForm.new
      render action: "new"
    end
  end

  def create
    @form = Admin::LoginForm.new(login_form_params)
    if @form.email.present?
      admin = Admin.find_by("email = ?", @form.email.downcase)
    end

    if Admin::Authenticator.new(admin).authenticate(@form.password)
      if admin.suspended?
         # suspendedがtrueの場合に表示されるフラッシュメッセージ
        flash.now.alert = "アカウントが停止されています。"
        render action: "new"
      else
        session[:admin_id] = admin.id
        #セッションタイムアウト用に記録する
        session[:admin_last_access_time] = Time.current
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
    redirect_to new_admin_session_path
  end

  private
  def login_form_params
    params.require(:admin_login_form).permit(:email, :password)
  end
end
