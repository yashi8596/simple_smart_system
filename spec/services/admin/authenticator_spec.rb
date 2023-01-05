require "rails_helper"

describe Admin::Authenticator do
  describe "#authenticate" do
    example "正しいパスワードならtrueを返す" do
      m = build(:admin)
      expect(Admin::Authenticator.new(m).authenticate("wa")).to be_truthy
    end

    example "誤ったパスワードならfalseを返す" do
      m = build(:admin)
      expect(Admin::Authenticator.new(m).authenticate("tv")).to be_falsey
    end

    example "パスワード未設定ならfalseを返す" do
      m = build(:admin, password: nil)
      expect(Admin::Authenticator.new(m).authenticate(nil)).to be_falsey
    end

    example "停止フラグが立っていてもtrueを返す" do
      m = build(:admin, suspended: true)
      expect(Admin::Authenticator.new(m).authenticate("wa")).to be_truthy
    end
  end
end