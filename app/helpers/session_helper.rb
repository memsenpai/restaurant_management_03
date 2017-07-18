module SessionHelper
  def log_in admin
    session[:admin_id] = admin.id
    cookies.signed[:admin_id] = admin.id
  end

  def current_admin
    @current_admin ||= Admin.find_by id: session[:admin_id]
  end

  def current_order id = nil
    order_id = session[:order_id] || id
    if order_id.present?
      Order.find_or_initialize_by id: order_id
    else
      Order.new
    end
  end

  def update_guest guest
    session[:guest] = guest
  end

  def logged_in?
    current_admin.present?
  end

  def log_out
    session.delete :admin_id
    @current_admin = nil
  end
end
