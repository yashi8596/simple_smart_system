#フォームオブジェクト（従業員側）

class Public::LoginForm
  include ActiveModel::Model

  attr_accessor :employee_number, :password
end