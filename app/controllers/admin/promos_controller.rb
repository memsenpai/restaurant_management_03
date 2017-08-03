module Admin
  class PromosController < ApplicationController
    before_action :authenticate_staff!
    before_action :load_dishes, except: %i(index update destroy)

    after_action :send_mail, only: %i(create)

    load_and_authorize_resource
    skip_load_resource only: %i(index new create)

    def index
      @promos = Supports::PromoSupport.new promos: Promo.all, param: params
    end

    def new
      @promo = Promo.new
      attach_respond
    end

    def create
      @promo = Promo.new promo_params

      if promo.save
        flash[:succes] = t "promo.create.success"
        redirect_to admin_promo_path promo
      else
        flash[:notice] = t "promo.create.notice"
        redirect_to :back
      end
    end

    def edit
      attach_respond
    end

    def show; end

    def update
      if promo.update_attributes promo_params
        flash[:succes] = t "promo.update.success"
        redirect_to admin_promo_path
      else
        flash[:notice] = t "promo.update.notice"
        redirect_to :back
      end
    end

    def destroy
      promo.destroy
      flash[:success] = t "promo.destroy.success"
      redirect_to :back
    end

    private

    attr_reader :promo

    def promo_params
      params.require(:promo).permit Promo::PERMIT_ATTR
    end

    def load_dishes
      @dishes = Dish.all
    end

    def find_image
      dish = Dish.find_by id: params[:dish_id]

      return t "no_content" unless dish
      dish.image
    end

    def attach_respond
      respond_to do |format|
        format.html
        format.json do
          render json: find_image.to_json
        end
      end
    end

    def send_mail
      NotifierMailer.adv_promos(promo).deliver
    end
  end
end
