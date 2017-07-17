class Admin
  class CombosController < ApplicationController
    before_action :logged_in_admin
    before_action :find_combo, except: %i(index new create)
    before_action :load_dishes, only: %i(new edit)

    def index
      @combos = Supports::Combo.new combo: Combo.all, param: params
    end

    def new
      @combo = Combo.new
    end

    def create
      @combo = Combo.new combo_params
      if @combo.save
        flash[:success] = t "flash.combo.create_success"
        redirect_to admin_combo_path @combo
      else
        load_dishes
        render :new
      end
    end

    def show
      @combo = Combo.includes(:dishes).find_by id: params[:id]
      @categories = Category.all
    end

    def edit
    end

    def update
      if @combo.update_attributes combo_params
        flash[:success] = t "flash.combo.update_success"
        redirect_to admin_combo_path @combo
      else
        redirect_to edit_admin_combo_path
      end
    end

    def destroy
      if @combo.destroy
        flash[:success] = t "flash.combo.destroy_success"
      else
        flash[:danger] = t "flash.combo.destroy_fail"
      end
      respond_to do |format|
        format.html{redirect_to :back}
        format.json{head :no_content}
      end
    end

    private
    def combo_params
      params.require(:combo).permit :name, :discount,
        :description, :image, dish_ids: []
    end

    def find_combo
      @combo = Combo.find_by id: params[:id]
      unless @combo
        flash[:danger] = t "flash.combo.find_fail"
        redirect_to admin_combos_path
      end
    end

    def load_dishes
      @dishes = Dish.all
    end
  end
end
