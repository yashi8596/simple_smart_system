#管理者をユーザーとして認証するためのサービスオブジェクト
class Admin::Authenticator
  def initialize(admin)
    @admin = admin
  end

  def authenticate(raw_password)
    @admin &&
      @admin.hashed_password &&
      BCrypt::Password.new(@admin.hashed_password) == raw_password
  end
end