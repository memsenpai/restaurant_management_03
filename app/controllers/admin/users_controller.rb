module Admin
  class UsersController < ApplicationController
    before_action :logged_in_admin
    before_action :find_user, only: %i(edit update destroy)

    authorize_resource class: :admin

    def index
      @list_admin =
        Administrator.all.page(params[:page]).per_page Settings.max_result
    end

    def new
      @admin = Administrator.new
    end

    def create
      @user = Administrator.new new_params
      if user.save
        flash[:success] = t "admin.success"
        redirect_to admin_users_path
      else
        flash[:danger] = t "admin_order.something_wrong"
        redirect_to :back
      end
    end

    def edit; end

    def update
      if user.update_attributes update_params
        flash[:success] = t "admin.success"
        redirect_to admin_users_path
      else
        flash[:danger] = t "admin_order.something_wrong"
        redirect_to edit_admin_user_path user
      end
    end

    def destroy
      if user.id != current_admin.id && user.destroy
        flash[:success] = t "admin.success"
      else
        flash[:danger] = t "admin_order.something_wrong"
      end
      redirect_to admin_users_path
    end

    private

    attr_reader :user

    def find_user
      @user = Administrator.find_by id: params[:id]

      return if user
      flash[:danger] = t "admin.not_exist"
      redirect_to admin_users_path
    end

    def new_params
      params.require(:administrator).permit :email,
        :password, :password_confirmation, :name, :admin_role
    end

    def update_params
      params.require(:administrator).permit :admin_role
    end
  end
end
