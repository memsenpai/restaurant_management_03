require "rails_helper"

describe DishesController do
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
    Dish.limit(10).each do |dish|
      it "show combo: #{dish.name}" do
        get :show, params: {id: dish.id}
        expect(response).to have_http_status :ok
      end
    end
  end
end
