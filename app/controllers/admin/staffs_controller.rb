module Admin
  class StaffsController < ApplicationController
    before_action :authenticate_staff!

    load_and_authorize_resource
    skip_load_resource except: %i(edit update destroy)

    def index
      @list_staff =
        Staff.all.page(params[:page]).per_page Settings.max_result
    end

    def new
      @admin = Staff.new
    end

    def create
      @staff = Staff.new new_params
      if staff.save
        flash[:success] = t "admin.success"
        redirect_to admin_staffs_path
      else
        flash[:danger] = t "staff_order.something_wrong"
        redirect_to :back
      end
    end

    def edit; end

    def update
      if staff.update_attributes update_params
        flash[:success] = t "admin.success"
        redirect_to admin_staffs_path
      else
        flash[:danger] = t "staff_order.something_wrong"
        redirect_to edit_admin_staff_path staff
      end
    end

    def destroy
      if staff.id != current_staff.id && staff.destroy
        flash[:success] = t "admin.success"
      else
        flash[:danger] = t "staff_order.something_wrong"
      end
      redirect_to admin_staffs_path
    end

    private

    attr_reader :staff

    def new_params
      params.require(:staff).permit :email,
        :password, :password_confirmation, :name, :staff_role
    end

    def update_params
      params.require(:staff).permit :staff_role
    end
  end
end
