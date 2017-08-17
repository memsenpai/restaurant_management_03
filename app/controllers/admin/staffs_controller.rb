module Admin
  class StaffsController < ApplicationController
    before_action :authenticate_staff!
    before_action :load_require

    load_and_authorize_resource
    skip_load_resource except: %i(edit update destroy)

    def index; end

    def create
      @staff = Staff.new new_params
      if staff.save
        flash[:success] = t "admin.success"
        render "admin/staffs/index.js.erb", locals: {list_staff: list_staff}
      else
        flash[:danger] = t "staff_order.something_wrong"
        redirect_to :back
      end
    end

    def edit; end

    def update
      if staff.update_attributes new_params
        flash[:success] = t "admin.success"
        render "admin/staffs/index.js.erb", locals: {list_staff: list_staff}
      else
        flash[:danger] = t "staff_order.something_wrong"
        redirect_to :back
      end
    end

    def destroy
      if staff.id != current_staff.id &&
         staff.update_attributes(deleted: true)
        flash[:success] = t "admin.success"
        return render "admin/staffs/index.js.erb",
          locals: {list_staff: list_staff}
      else
        flash[:danger] = t "staff_order.something_wrong"
      end
      redirect_to admin_staffs_path
    end

    private

    attr_reader :staff, :list_staff

    def new_params
      params.require(:staff).permit Staff::ATTRIBUTES
    end

    def load_require
      @list_staff =
        Staff.where(deleted: false).page(params[:page])
          .per_page(Settings.max_result)
    end
  end
end
