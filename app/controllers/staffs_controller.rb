class StaffsController < ApplicationController
  before_action :authenticate_staff!

  def show
    return if current_staff
    flash[:danger] = t "admin.error_log"
    redirect_to root_url
  end

  def edit; end

  def update
    if check_old_pass && current_staff.update_attributes(select_params)
      flash[:success] = t "admin.success"
      redirect_to staffs_path
    else
      flash[:danger] = t "admin.fail"
      render :edit
    end
  end

  private

  attr_reader :staff

  def staff_params
    params.require(:staff).permit :name,
      :email, :old_password, :password, :password_confirmation
  end

  def select_params
    selected_params =
      case staff_params[:password]
      when ""
        %i(name email).freeze
      when admin_params[:password_confirmation]
        %i(name email password).freeze
      end
    params.require(:staff).permit selected_params
  end

  def check_old_pass
    current_staff
      .valid_for_custom_authentication? params[:staff][:old_password]
  end
end
