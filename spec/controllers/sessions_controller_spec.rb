require "rails_helper"

describe SessionsController do
  before :each do
    @request.host = "localhost:3000"
    @request.env["devise.mapping"] = Devise.mappings[:staff]
  end

  describe "Get #new" do
    it "test new" do
      get :new
      expect(response).to have_http_status 200
    end
  end

  describe "POST #create" do
    it "test login success" do
      post :create, params:
        {staff: {email: "admin@123.com", password: "123123"}}
      expect(response).to have_http_status 200
    end

    it "test login failure" do
      post :create, params:
        {staff: {email: "admin@123.com", password: "1231233"}}
      expect(response).to render_template :new
    end
  end

  describe "Destroy #destroy" do
    it "destroy" do
      get :destroy
      expect(response).to have_http_status 302
    end
  end
end
