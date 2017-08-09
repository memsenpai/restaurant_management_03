module Admin
  class UpdateItemsController < ApplicationController
    before_action :load_params, only: :update

    def update
      unless data.value_status == data.status_current
        list_items.order(cooking_time: :desc) if data.status == "cancel"
        split_items
      end
      redirect_to :back
    end

    private

    attr_reader :data, :list_items

    def update_params
      params.require(:update_item).permit :quantity, :item_id, :status, :type,
        :status_current
    end

    def check_quantity item
      if item.quantity <= data.quantity
        return true if data.quantity_less item
      else
        data.quantity_than item
        true
      end
    end

    def split_items
      list_items.map do |item|
        break if check_quantity item
      end
    end

    def load_params
      @data = Supports::AdminUpdateItemSupport.new update_params
      @list_items = data.type.constantize
        .where(data.item_id.to_sym => data.id, status: data.status_current)
        .order(cooking_time: :asc)
    end
  end
end
