class Admin::OrderCombosController < ApplicationController
  include AdminLoadOrder
  before_action :logged_in_admin
  before_action :load_support_combos
  before_action :find_order_combo

  load_and_authorize_resource

  def new
    @order_combo = OrderCombo.new
    link = "_order_combo_item"
    respond_to do |format|
      format.html{render link, layout: false, locals: {support: @support}}
    end
  end

  def create
    order = @support.load_data[:order]
    @order_combo = order.order_combos.new order_combo_params
    if order.save!
      flash[:success] = t "admin_order.success_add"
      l = "admin/orders/_order_item"
      respond_to do |f|
        f.html{render l, layout: false, locals: {order: order}}
      end
    else
      flash[:danger] = t "admin_order.something_wrong"
      redirect_to :back
    end
  end

  def edit
  end

  def update
    params_update = order_combo_params
    if @order_combo.update_attributes params_update
      flash[:success] = t "admin_order.success_update"
      if params_update[:status] != "no_need"
        ActionCable.server.broadcast "messages",
          from_role: current_admin.admin_role,
          dish: @order_combo.combo.name,
          table: @order_combo.order.table.code,
          status: @order_combo.status
      end
    else
      flash[:danger] = t "admin_order.something_wrong"
    end
    redirect_to :back
  end

  def destroy
    order = @support.load_data[:order]
    if order
      order_combo = order.order_combos
      if order_combo.delete @order_combo
        flash[:success] = t "admin_order.success_delete"
      else
        flash[:danger] = t "admin_order.something_wrong"
      end
    end
    redirect_to :back
  end

  private
  def order_combo_params
    params.require(:order_combo).permit :combo_id, :quantity, :status
  end
end
