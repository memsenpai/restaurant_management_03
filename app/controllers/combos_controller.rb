class CombosController < ApplicationController
  before_action :find_combo, only: :show

  def index
    @combo_support = Supports::Combo.new combo: Combo.all, param: params
  end

  def show
    @order_combo = current_order.order_combos.new
  end

  private

  attr_reader :combo

  def find_combo
    combo = Combo.find_by id: params[:id]

    return if combo
    flash[:danger] = t "flash.combo.find_fail"
    redirect_to combos_path
  end
end
