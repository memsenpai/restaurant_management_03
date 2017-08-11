module Supports
  class AdminUpdateItemSupport
    attr_reader :quantity, :data, :reason_params

    def initialize arg, reason_params = nil
      @data = arg
      @quantity = arg[:quantity].to_i
      @reason_params = reason_params
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

    def item_id
      type.downcase[5..-1] << "_id"
    end

    def id
      data[:item_id]
    end

    def quantity_than item
      name_model = type.constantize
      cancel_status name_model.create!(order_id: item.order_id,
        item_id.to_sym => item.send(item_id),
        quantity: quantity,
        cooking_time: item.cooking_time,
        status: name_model.statuses.key(status.to_i))
      cancel_update item
    end

    def quantity_less item
      item.send("#{type.constantize.statuses.key status.to_i}!")
      quantity_reduce item.quantity
      cancel_status item
      quantity.zero?
    end

    private

    def cancel_update item
      cancel_status item
      item.update_attributes quantity: (item.quantity - quantity)
    end

    def cancel_status item
      return if value_status != "cancel" || reason_params.blank?
      item.reasons.new reason_params
      item.save!
    end
  end
end
