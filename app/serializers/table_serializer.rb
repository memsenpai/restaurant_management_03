class TableSerializer < ActiveModel::Serializer
  attributes :id, :capacity, :code, :available

  def available
    object.is_available?
  end
end
