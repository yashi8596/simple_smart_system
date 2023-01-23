#ストロングパラメータ機能確認のテスト
require "rails_helper"

describe "管理者による従業員管理" do
  let(:admin) { create(:admin) }

  describe "新規登録" do
    let(:params_hash) { attributes_for(:employee) }

    example "従業員詳細ページにリダイレクト" do
      post admin_employees_url, params: { employee: params_hash }
      expect(response).to redirect_to(admin_employee_url(12345678))
    end

    example "例外ActionController::ParameterMissingが発生" do
      expect { post admin_employees_url }.to raise_error(ActionController::ParameterMissing)
    end
  end

  describe "更新" do
    let(:employee) { create(:employee) }
    let(:params_hash) { attributes_for(:employee) }

    example "suspendedフラグをセットする" do
      params_hash.merge!(suspended: true)
      patch admin_employee_url(employee),
        params: { employee: params_hash }
      employee.reload
      expect(employee).to be_suspended
    end

    example "hashed_passwordの値は書き換え不可" do
      params_hash.delete(:password)
      params_hash.merge!(hashed_password: "x")
      expect {
        patch admin_employee_url(employee),
          params: { employee: params_hash }
      }.not_to change { employee.hashed_password.to_s }
    end
  end
end