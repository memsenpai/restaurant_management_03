require "rails_helper"

describe CombosController do
  before :each do
    @request.host = "localhost:3000"
  end

  describe "GET #index" do
    it "index" do
      get :index
      expect(response).to have_http_status :ok
    end
  end

  describe "GET #show" do
    Combo.limit(10).each do |combo|
      it "show combo: #{combo.name}" do
        get :show, params: {id: combo.id}
        expect(response).to have_http_status :ok
      end
    end
  end
end
