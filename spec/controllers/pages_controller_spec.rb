require "rails_helper"

describe PagesController do
  before :each do
    @request.host = "localhost:3000"
  end

  describe "GET #show" do
    it "show home page" do
      get :show, params: {page: :home}
      expect(response).to have_http_status :ok
    end
  end
end
