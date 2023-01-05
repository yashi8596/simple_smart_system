#フォームオブジェクト（従業員側）
#このアプリでは管理者側から「従業員登録・削除を実行したい」ため、deviseは使用しません。

class Public::LoginForm
  include ActiveModel::Model

  attr_accessor :employee_number, :password
end