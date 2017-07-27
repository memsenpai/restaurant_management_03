require "rails_helper"

describe OrdersController do
  before :each do
    @request.host = "localhost:3000"
  end

  describe "GET #index" do
    it "show index order" do
      get :index
      expect(response).to have_http_status :ok
    end
  end
end
