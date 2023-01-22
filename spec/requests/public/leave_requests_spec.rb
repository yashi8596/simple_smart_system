require 'rails_helper'

RSpec.describe "Public::LeaveRequests", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/public/leave_requests/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      post "/public/leave_requests/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/public/leave_requests/show"
      expect(response).to have_http_status(:success)
    end
  end

end
