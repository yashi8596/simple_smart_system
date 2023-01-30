require "rails_helper"

describe "従業員自身によるアカウント管理", "ログイン前" do
  include_examples "a protected singular employee controller", "public/employees"
end

describe "従業員自身によるアカウントの管理" do
  before do
    post session_url, params: { public_login_form: { employee_number: employee.id, password: "pw" } }
  end

  describe "情報開示" do
    #強制ログアウト・セッションタイムアウトのテスト
    let(:employee) { create(:employee) }

    example "成功" do
      get root_path
      expect(response.status).to eq(200)
    end

    example "停止フラグが有効になったら強制的にログアウトさせる" do
      employee.update_column(:suspended, true)
      get new_session_url
      expect(response).to redirect_to new_session_url
    end

    example "セッションタイムアウト確認" do
      travel_to Public::Base::TIMEOUT.from_now.advance(seconds: 1)
      get root_path
      expect(response).to redirect_to new_session_url
    end
  end

  describe "更新" do
    let(:employee) { create(:employee) }
    let(:params_hash) { attributes_for(:employee) }

    example "email属性を変更する" do
      params_hash.merge!(email: "test@example.com")
      patch employee_url, params: { id: employee.id, employee: params_hash }
      employee.reload
      expect(employee.email).to eq("test@example.com")
    end

    example "例外ActionController::ParameterMissingが発生" do
      expect { patch employee_url(employee), params: { id: employee.id } }.to raise_error(ActionController::ParameterMissing)
    end

    example "end_dateの書き換えは不可" do
      params_hash.merge!(end_date: Date.tomorrow)
      expect { patch employee_url(employee), params: { id: employee.id, employee: params_hash } }.not_to change { employee.end_date }
    end
  end
end