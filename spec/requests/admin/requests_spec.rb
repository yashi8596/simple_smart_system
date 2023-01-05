require 'rails_helper'

RSpec.describe "Admin::Requests", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/admin/requests/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/admin/requests/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/admin/requests/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/admin/requests/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/admin/requests/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
