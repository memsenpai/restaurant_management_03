module Supports
  class AdminOrderComboSupport
    def combos status
      order_combos = OrderCombo.send(status).sort_by(&:cooking_time)
      merge_duplication order_combos
    end

    private

    def delete_duplication combo, order_combos
      order_combos.map do |combo_delete|
        id = combo_delete.id
        if combo.combo_id == combo_delete.combo_id && combo.id != id
          combo.quantity += combo_delete.quantity
          order_combos.delete_if{|item| item.id == id}
        end
      end
    end

    def merge_duplication order_combos
      order_combos.map do |combo|
        delete_duplication combo, order_combos
      end
      order_combos
    end
  end
end
