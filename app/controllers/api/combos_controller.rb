module Api
  class CombosController < Api::BaseController
    before_action :find_combo, only: %i(show)

    def index
      render json: Combo.all
    end

    def show
      render json: combo.dishes
    end

    private

    attr_reader :combo

    def find_combo
      @combo = Combo.find_by id: params[:id]

      return if combo
      render json: Array.new, status: :not_found
    end
  end
end
