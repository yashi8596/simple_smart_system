#ストロングパラメータ機能確認のテスト
require "rails_helper"

describe "管理者による従業員管理" do
  let(:admin) { create(:admin) }

  describe "新規登録" do
    let(:params_hash) { attributes_for(:employee) }

    example "従業員一覧ページにリダイレクト" do
      post admin_employees_path, params: { employee: params_hash }
      expect(response).to redirect_to(admin_root_path)
    end

    example "例外ActionController::ParameterMissingが発生" do
      expect { post admin_employees_path }.to raise_error(ActionController::ParameterMissing)
    end
  end

  describe "更新" do
    let(:employee) { create(:employee) }
    let(:params_hash) { attributes_for(:employee) }
  end
end