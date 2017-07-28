class Combo < ApplicationRecord
  COMBO_ATTRIBUTES = [
    :name, :discount,
    :description, :image, dish_ids: []
  ].freeze

  ratyrate_rateable "nice"
  has_many :combo_dishes
  has_many :dishes, through: :combo_dishes, dependent: :destroy
  has_many :order_combos

  validates :name, presence: true
  validates :discount, presence: true, numericality: {greater_than: 0}

  popular_combos = lambda do
    joins(:order_combos).group("combos.id")
      .order("count(combos.id) desc").limit 10
  end

  scope :popular_combos, popular_combos

  def subtotal
    combo_dishes.map{|combo_dish| combo_dish.dish.price}.sum
  end

  def price
    (subtotal * (100 - discount)) / 100
  end

  def find_discount
    discount
  end
end
