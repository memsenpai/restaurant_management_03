require "rails_helper"

describe CustomersController do
  before :each do
    @request.host = "localhost:3000"
  end

  describe "GET #create" do
    it "create a new guest" do
      post :new, params:
        {guest: {name: "A", email: "a@a.xxx", phone_num: "0977903921"}},
        format: :json
      expect(response).to have_http_status 204
    end
  end
end
