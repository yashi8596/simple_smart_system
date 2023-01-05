require "rails_helper"

describe Public::Authenticator do
  describe "#authenticate" do
    example "正しいパスワードならtrueを返す" do
      m = build(:employee)
      expect(Public::Authenticator.new(m).authenticate("pw")).to be_truthy
    end

    example "誤ったパスワードならfalseを返す" do
      m = build(:employee)
      expect(Public::Authenticator.new(m).authenticate("xy")).to be_falsey
    end

    example "パスワード未設定ならfalseを返す" do
      m = build(:employee, password: nil)
      expect(Public::Authenticator.new(m).authenticate(nil)).to be_falsey
    end

    example "停止フラグが立っていてもtrueを返す" do
      m = build(:employee, suspended: true)
      expect(Public::Authenticator.new(m).authenticate("pw")).to be_truthy
    end

    example "開始前ならfalseを返す" do
      m = build(:employee, start_date: Date.tomorrow)
      expect(Public::Authenticator.new(m).authenticate("pw")).to be_falsey
    end

    example "終了後ならfalseを返す" do
      m = build(:employee, end_date: Date.today)
      expect(Public::Authenticator.new(m).authenticate("pw")).to be_falsey
    end
  end
end