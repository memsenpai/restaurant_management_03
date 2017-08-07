module Supports
  class AdminUpdateItemSupport
    attr_reader :quantity, :item_id, :data

    def initialize arg
      @data = arg
      @quantity = arg[:quantity].to_i
      @item_id = type.downcase[5..-1] << "_id"
    end

    def quantity_reduce value
      @quantity -= value
    end

    def status
      data[:status]
    end

    def value_status
      type.constantize.statuses.key(status.to_i)
    end

    def status_current
      data[:status_current]
    end

    def type
      data[:type]
    end

    def id
      data[:item_id]
    end

    def quantity_than item
      name_model = type.constantize
      name_model.create! order_id: item.order_id,
        item_id.to_sym => item.send(item_id),
        quantity: quantity,
        cooking_time: item.cooking_time,
        status: name_model.statuses.key(status.to_i)
      item.update_attributes quantity: (item.quantity - quantity)
    end

    def quantity_less item
      item.send("#{type.constantize.statuses.key status.to_i}!")
      quantity_reduce item.quantity
      quantity.zero?
    end
  end
end
