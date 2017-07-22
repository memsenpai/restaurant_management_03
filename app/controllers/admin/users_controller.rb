module Admin
  class UsersController < ApplicationController
    before_action :authenticate_staff!
    before_action :find_user, only: %i(edit update destroy)

    authorize_resource class: :admin

    def index
      @list_staff =
        Staff.all.page(params[:page]).per_page Settings.max_result
    end

    def new
      @admin = Staff.new
    end

    def create
      @user = Staff.new new_params
      if user.save
        flash[:success] = t "admin.success"
        redirect_to admin_users_path
      else
        flash[:danger] = t "staff_order.something_wrong"
        redirect_to :back
      end
    end

    def edit; end

    def update
      if user.update_attributes update_params
        flash[:success] = t "admin.success"
        redirect_to admin_users_path
      else
        flash[:danger] = t "staff_order.something_wrong"
        redirect_to edit_admin_user_path user
      end
    end

    def destroy
      if user.id != current_staff.id && user.destroy
        flash[:success] = t "admin.success"
      else
        flash[:danger] = t "staff_order.something_wrong"
      end
      redirect_to admin_users_path
    end

    private

    attr_reader :user

    def find_user
      @user = Staff.find_by id: params[:id]

      return if user
      flash[:danger] = t "admin.not_exist"
      redirect_to admin_users_path
    end

    def new_params
      params.require(:staff).permit :email,
        :password, :password_confirmation, :name, :staff_role
    end

    def update_params
      params.require(:staff).permit :staff_role
    end
  end
end
