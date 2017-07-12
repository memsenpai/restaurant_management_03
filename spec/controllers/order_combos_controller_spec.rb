require "rails_helper"

describe OrderCombosController do
  FactoryGirl.create :combo
  before :each do
    @request.host = "localhost:3000"
  end

  describe "GET #create" do
    it "add combo into order" do
      post :create, params:
        {order_combo: {quantity: 1, combo_id: Combo.first.id}},
        format: :json
      expect(response).to have_http_status 204
    end
  end
end
