class Supports::DiscountCode
  attr_reader :discount_codes

  def initialize arg
    @discounts = arg
  end

  def discounts
    @discounts[:discount]
  end

  def discounts_search
    search.result.page(@discounts[:param][:page]).per_page Settings.discount
  end

  def search
    search = DiscountCode.ransack @discounts[:param][:q]
    search.sorts = %w(code discount status) if search.sorts.empty?
    search
  end
end
