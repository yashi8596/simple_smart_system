require "rails_helper"

describe "従業員自身によるアカウントの管理" do
  before do
    post sessions_path, params: { public_login_form: { email: employee.email, password: "pw" } }
  end

  describe "更新" do
    let(:params_hash) { attributes_for(:employee) }
    let(:employee) { create(:employee) }

    example "email属性を変更する" do
      params_hash.merge!(email: "test@example.com")
      patch employees_path, params: { employee_number: employee.employee_number, employee: params_hash }
      employee.reload
      expect(employee.email).to eq("test@example.com")
    end

    example "例外ActionController::ParameterMissingが発生" do
      expect { patch employees_path, params: { employee_number: employee.employee_number } }.to raise_error(ActionController::ParameterMissing)
    end

    example "end_dateの書き換えは不可" do
      params_hash.merge!(end_date: Date.tomorrow)
      expect { patch employees_path, params: { employee_number: employee.employee_number, employee: params_hash } }.not_to change { employee.end_date }
    end
  end
end