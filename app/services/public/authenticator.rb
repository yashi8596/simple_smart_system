#従業員をユーザーとして認証するためのサービスオブジェクト
class Public::Authenticator
  def initialize(employee)
    @employee = employee
  end

  def authenticate(raw_password)
    @employee &&
      @employee.hashed_password &&
      @employee.start_date <= Date.today && #開始日がDate.today以前であるか
      (@employee.end_date.nil? || @employee.end_date > Date.today) && #終了日がnil、またはDate.today以降であるか
      BCrypt::Password.new(@employee.hashed_password) == raw_password
  end
end