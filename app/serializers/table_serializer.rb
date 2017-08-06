class TableSerializer < ActiveModel::Serializer
  attributes :id, :capacity, :code, :available, :order_id

  def available
    object.is_available?
  end

  def order_id
    object.orders.serving.first
  end
end
