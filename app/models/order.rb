class Order < ApplicationRecord
  include Encode
  belongs_to :guest
  belongs_to :table, inverse_of: :orders
  delegate :capacity, to: :table

  has_many :order_dishes
  has_many :order_combos
  has_one :bill, foreign_key: "code"

  after_save :generate_code

  accepts_nested_attributes_for :guest
  accepts_nested_attributes_for :table

  def subtotal
    subtotal_combos_map.sum + subtotal_dishes_map.sum
  end

  def original_price
    original_combos_map.sum + original_dishes_map.sum
  end

  def original_combos_map
    order_combos.map do |order_combo|
      order_combo.valid? ? order_combo.quantity * order_combo.original_price : 0
    end
  end

  def original_dishes_map
    order_dishes.map do |order_dish|
      order_dish.valid? ? order_dish.quantity * order_dish.price : 0
    end
  end

  def subtotal_combos_map
    order_combos.map do |order_combo|
      order_combo.valid? ? order_combo.total_price : 0
    end
  end

  def subtotal_dishes_map
    order_dishes.map do |order_dish|
      order_dish.valid? ? order_dish.total_price : 0
    end
  end
end
