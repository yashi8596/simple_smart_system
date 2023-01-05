#フォームオブジェクト（管理者側）

class Admin::LoginForm
  include ActiveModel::Model

  attr_accessor :email, :password
end