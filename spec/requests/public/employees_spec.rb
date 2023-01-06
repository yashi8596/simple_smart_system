require 'rails_helper'

RSpec.describe "Public::Employees", type: :request do
  describe "GET /edit" do
    it "returns http success" do
      get "/public/employees/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/public/employees/update"
      expect(response).to have_http_status(:success)
    end
  end

end
