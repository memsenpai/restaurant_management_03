module Admin
  class MembershipCouponsController < ApplicationController
    before_action :find_membership_coupon, only: :update

    def index
      @membership_coupons = Supports::MembershipCouponSupport
        .new membership_coupons: MembershipCoupon.all, param: params
    end

    def create
      @membership_coupon = MembershipCoupon.new membership_coupon_params
      if membership_coupon.save
        render json: {data: membership_coupon}
      else
        render json: nil
      end
    end

    def update
      if membership_coupon.update_attributes membership_coupon_params
        render json: {status: 1}
      else
        render json: {status: 0}
      end
    end

    private

    attr_reader :membership_coupon

    def find_membership_coupon
      @membership_coupon = MembershipCoupon.find_by id: params[:id]
      redirect_to admin_membership_coupons unless membership_coupon
    end

    def membership_coupon_params
      params.require(:membership_coupon).permit :name, :money_paid, :discount
    end
  end
end
