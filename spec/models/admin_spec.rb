require 'rails_helper'

RSpec.describe Admin, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  describe "#password=" do
    example "文字列を与えると、hashed_passwordは長さ60の文字列になる" do
      admin = Admin.new
      admin.password = "rubyonrails"
      expect(admin.hashed_password).to be_kind_of(String)
      expect(admin.hashed_password.size).to eq(60)
    end
  end

  example "nilを与えると、hashed_passwordはnilになる" do
    admin = Admin.new(hashed_password: "x")
    admin.password = nil
    expect(admin.hashed_password).to be_nil
  end
end
