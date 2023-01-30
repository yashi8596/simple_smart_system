#before_action :authorizeの確認テスト
shared_examples "a protected admin controller" do |controller|
  let(:args) do
    {
      controller: "admin/employees"
    }
  end

  describe "#new" do
    example "ログインフォームにリダイレクト" do
      get url_for(args.merge(action: :new))
      expect(response).to redirect_to new_admin_session_url
    end
  end

  describe "#show" do
    example "ログインフォームにリダイレクト" do
      get url_for(args.merge(action: :show, id: 1))
      expect(response).to redirect_to new_admin_session_url
    end
  end

  describe "#edit" do
    example "ログインフォームにリダイレクト" do
      get url_for(args.merge(action: :edit, id: 1))
      expect(response).to redirect_to new_admin_session_url
    end
  end

  describe "#confirm" do
    example "ログインフォームにリダイレクト" do
      get url_for(args.merge(action: :confirm, id: 1))
      expect(response).to redirect_to new_admin_session_url
    end
  end
end