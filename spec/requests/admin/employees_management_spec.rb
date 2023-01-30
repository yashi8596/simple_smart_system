#ストロングパラメータ機能確認のテスト
require "rails_helper"

describe "管理者による従業員管理", "ログイン前" do
  include_examples "a protected admin controller", "admin/employees"
end

describe "管理者による従業員管理" do
  let(:admin) { create(:admin) }

  before do
    post admin_session_url,
      params: { admin_login_form: { email: admin.email, password: "wa" } }
  end

  describe "情報開示" do
    example "成功" do
      get admin_root_path
      expect(response.status).to eq(200)
    end

    example "停止フラグが有効になったら強制的にログアウト" do
      admin.update_column(:suspended, true)
      get admin_root_path
      expect(response).to redirect_to new_admin_session_url
    end

    example "セッションタイムアウトの確認" do
      travel_to Admin::Base::TIMEOUT.from_now.advance(seconds: 1)
      get admin_root_url
      expect(response).to redirect_to new_admin_session_url
    end
  end

  describe "新規登録" do
    let(:params_hash) { attributes_for(:employee) }

    example "従業員詳細ページにリダイレクト" do
      post admin_employees_url, params: { employee: params_hash }
      expect(response).to redirect_to admin_employee_url(12345678)
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