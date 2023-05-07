require 'rails_helper'

RSpec.describe "Admin::TimeRecords", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/admin/time_records/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/admin/time_records/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/admin/time_records/update"
      expect(response).to have_http_status(:success)
    end
  end

end
