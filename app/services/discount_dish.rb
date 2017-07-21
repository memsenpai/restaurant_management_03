class DiscountDish
  def initialize param
    @discount_dish = param
  end

  def discount
    find_discount
  end

  private

  attr_reader :discount_dish

  def find_discount
    time = discount_dish.created_at
    promos = Promo.find_discount discount_dish.dish_id,
      time, time
    promos.empty? ? 0 : promos.first.discount
  end
end
