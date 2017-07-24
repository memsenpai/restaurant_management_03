module Admin
  class ComboDishesController < ApplicationController
    before_action :authenticate_staff!
    before_action :find_combo_dishes

    def destroy
      combo_dish.destroy
      redirect_to :back
    end

    private

    attr_reader :combo_dish

    def find_combo_dishes
      @combo_dish = ComboDish.find_by dish_id: params[:id]

      return if combo_dish
      redirect_to admin_categories_path
    end
  end
end
