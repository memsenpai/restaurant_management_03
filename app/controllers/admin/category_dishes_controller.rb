module Admin
  class CategoryDishesController < ApplicationController
    before_action :authenticate_staff!
    before_action :find_category_dishes

    def destroy
      category_dish.destroy
      redirect_to :back
    end

    private

    attr_reader :category_dish

    def find_category_dishes
      @category_dish = CategoryDish.find_by dish_id: params[:id]

      return if category_dish
      redirect_to admin_categories_path
    end
  end
end
