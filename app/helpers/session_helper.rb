module SessionHelper
  def current_order id = nil
    order_id = session[:order_id] || id
    if order_id.present?
      Order.find_or_initialize_by id: order_id
    else
      Order.new
    end
  end

  def order_save?
    current_order.table_id.present?
  end

  def current_order_checked?
    current_order.done? || current_order.approved? || current_order.serving?
  end

  def disable_status? order
    order.done? || order.declined? || order.serving?
  end

  def check_item_in_order?
    return true if params[:controller] == "orders"
    dish = Dish.find_by id: session[:dish_id]
    combo = Combo.find_by id: session[:combo_id]
    current_order.order_dishes.map(&:dish).include?(dish) ||
      current_order.order_combos.map(&:combo).include?(combo)
  end

  def current_user
    return unless check_item_in_order?
    Customer.find_by id: session[:customer_id]
  end

  def current_item id, item
    item = item.constantize.find_by id: id

    return unless item
    item
  end

  def total_item_cart
    total("order_dishes") + total("order_combos")
  end

  def load_info id, *arg
    item = arg[0].constantize.find_by id: id
    price = item.price

    return unless item
    check_arg item, price, arg
  end

  private

  def check_arg item, price, arg
    case arg[1]
    when "name"
      item.name
    when "price"
      number_to_currency price
    when "total_price"
      number_to_currency(price * arg[2].to_i)
    end
  end

  def total items
    total_items = session[items.to_sym]

    return 0 unless total_items
    total_items.map{|item| item["quantity"].to_i}.sum
  end
end
