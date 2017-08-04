module Api
  class DishesController < Api::BaseController
    before_action :find_dish, only: %i(show)

    def index
      render json: Dish.all
    end

    def show
      render json: dish
    end

    private

    attr_reader :dish

    def find_dish
      @dish = Dish.find_by id: params[:id]

      return if dish
      render json: Array.new, status: :not_found
    end
  end
end
