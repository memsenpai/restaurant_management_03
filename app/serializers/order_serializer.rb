class OrderSerializer < ActiveModel::Serializer
  attributes :id, :customer_id, :table_id, :code, :day, :time_in, :discount,
    :status, :created_at, :updated_at
  has_many :foods

  def foods
    object.order_dishes + object.order_combos
  end
end
