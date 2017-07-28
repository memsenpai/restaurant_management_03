class RaterController < ApplicationController
  def create
    if current_order.done?
      obj = params[:klass].classify.constantize.find(params[:id])
      obj.rate params[:score].to_f, current_user, params[:dimension]
      render_rate
    else
      render json: false
    end
  end

  private

  def render_rate
    type = params[:klass]
    id = params[:id]
    render "orders/rate'",
      locals: {
        name: type + id,
        id: id, type: type
      }
  end
end
