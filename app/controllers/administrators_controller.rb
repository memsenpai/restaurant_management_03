class AdministratorsController < ApplicationController
  before_action :logged_in_admin

  def show
    return if current_admin
    flash[:danger] = t "admin.error_log"
    redirect_to root_url
  end

  def edit; end

  def update
    check_pass_and_update
  end

  private

  attr_reader :current_admin

  def admin_params
    params.require(:administrator).permit :name,
      :email, :old_password, :password, :password_confirmation
  end

  def select_params
    selected_params =
      case admin_params[:password]
      when ""
        %i(name email)
      when admin_params[:password_confirmation]
        %i(name email password)
      end
    params.require(:administrator).permit selected_params
  end

  def check_old_pass
    current_admin.authenticate(params[:administrator][:old_password]).present?
  end

  def check_pass_and_update
    if check_old_pass && current_admin.update_attributes(select_params)
      flash[:success] = t "admin.success"
      redirect_to admin_path
    else
      flash[:danger] = t "admin.fail"
      render :edit
    end
  end
end
