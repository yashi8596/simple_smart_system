require 'rails_helper'

RSpec.describe "Public::TimeRecords", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/public/time_records/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/public/time_records/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/public/time_records/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /index" do
    it "returns http success" do
      get "/public/time_records/index"
      expect(response).to have_http_status(:success)
    end
  end

end
