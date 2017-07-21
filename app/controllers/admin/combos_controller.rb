module Admin
  class CombosController < ApplicationController
    before_action :authenticate_staff!
    before_action :find_combo, except: %i(index new create).freeze
    before_action :load_dishes, only: %i(new edit).freeze

    def index
      @combos = Supports::ComboSupport.new combo: Combo.all, param: params
    end

    def new
      @combo = Combo.new
    end

    def create
      @combo = Combo.new combo_params
      if combo.save
        flash[:success] = t "flash.combo.create_success"
        redirect_to admin_combo_path combo
      else
        load_dishes
        render :new
      end
    end

    def show
      @combo = Combo.includes(:dishes).find_by id: params[:id]
      @categories = Category.all
    end

    def edit; end

    def update
      if combo.update_attributes combo_params
        flash[:success] = t "flash.combo.update_success"
        redirect_to admin_combo_path combo
      else
        load_dishes
        render :edit
      end
    end

    def destroy
      if combo.destroy
        flash[:success] = t "flash.combo.destroy_success"
      else
        flash[:danger] = t "flash.combo.destroy_fail"
      end
      redirect_to :back
    end

    private

    attr_reader :combo

    def combo_params
      params.require(:combo).permit :name, :discount,
        :description, :image, dish_ids: []
    end

    def find_combo
      @combo = Combo.find_by id: params[:id]
      return if combo
      flash[:danger] = t "flash.combo.find_fail"
      redirect_to admin_combos_path
    end

    def load_dishes
      @dishes = Dish.all
    end
  end
end
