module Admin
  class ChefController < ApplicationController
    before_action :authenticate_staff!

    load_and_authorize_resource class: :chef

    def index
      @needing_dishes = OrderDish.needing
      @needing_combos = OrderCombo.needing
      cooking_dishes = OrderDish.cooking
      cooking_combos = OrderCombo.cooking
      render locals: {
        cooking_dishes: cooking_dishes,
        cooking_combos: cooking_combos
      }
    end
  end
end
