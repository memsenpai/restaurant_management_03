class SessionsController < ApplicationController
  def new
    redirect_to admin_path if logged_in?
  end

  def create
    admin = Admin.find_by email: session_params[:email].downcase
    if admin && admin.authenticate(session_params[:password])
      log_in admin
      case admin.role
      when "Administrator"
        redirect_to admin
      when "Chef"
        redirect_to admin_chef_index_path
      when "Receptionist"
        redirect_to admin_orders_path
      end
    else
      flash.now[:danger] = t "admin.error_wrongpass"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to login_path
  end

  private

  def session_params
    params.require(:session).permit :email, :password
  end
end
