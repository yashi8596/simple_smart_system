#before_action :loginの確認テスト
shared_examples "a protected singular employee controller" do |controller|
  let(:args) do
    {
      controller: "public/employees"
    }
  end

  describe "#edit" do
    example "ログインフォームにリダイレクト" do
      get url_for(args.merge(action: :edit))
      expect(response).to redirect_to new_session_url
    end
  end
end