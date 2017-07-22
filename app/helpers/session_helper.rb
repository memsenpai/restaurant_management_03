module SessionHelper
  def current_order id = nil
    order_id = session[:order_id] || id
    if order_id.present?
      Order.find_or_initialize_by id: order_id
    else
      Order.new
    end
  end
end
