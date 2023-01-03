require 'rails_helper'

RSpec.describe Employee, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  describe "#password=" do
    example "文字列を与えると、hashed_passwordは長さ60の文字列になる" do
      employee = Employee.new
      employee.password = "dmmwebcamp"
      expect(employee.hashed_password).to be_kind_of(String)
      expect(employee.hashed_password.size).to eq(60)
    end
  end

  example "nilを与えると、hashed_passwordはnilになる" do
    employee = Employee.new(hashed_password: "x")
    employee.password = nil
    expect(employee.hashed_password).to be_nil
  end
end
