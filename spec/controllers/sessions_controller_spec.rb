require "rails_helper"

describe SessionsController do
  before :each do
    @request.host = "localhost:3000"
  end

  describe "POST #create" do
    it "test login success" do
      post :create, params: {session: {email: "admin@123.com", password: "123123"}}
      expect(response).to have_http_status 200
    end

    it "test login failure" do
      post :create, params: {session: {email: "admin@123.com", password: "1231233"}}
      expect(response).to render_template :new
    end
  end
end
