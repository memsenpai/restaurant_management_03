module Supports
  class MembershipCouponSupport
    attr_reader :membership_coupons, :param

    def initialize arg
      @membership_coupons = arg[:membership_coupons]
      @param = arg [:param]
    end

    def membership_coupons_search
      search.result.page(param[:page]).per_page Settings.limit
    end

    def search
      search = MembershipCoupon.ransack param[:q]
      search.sorts = "money_paid asc" if search.sorts.empty?
      search
    end

    def filter_active
      search.result.active.page(param[:page])
        .per_page Settings.limit
    end
  end
end
