require 'rails_helper'

RSpec.describe "Platforms", type: :request do

  describe "GET /show" do
    it "returns http success" do
      get "/platforms/show"
      expect(response).to have_http_status(:success)
    end
  end

end
