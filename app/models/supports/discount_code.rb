class Supports::DiscountCode
  attr_reader :discounts, :param

  def initialize arg
    @discounts = arg[:discount]
    @param = arg[:param]
  end

  def discounts_search
    search.result.page(param[:page]).per_page Settings.discount
  end

  def search
    search = DiscountCode.ransack param[:q]
    search.sorts = %w(code discount status) if search.sorts.empty?
    search
  end
end
