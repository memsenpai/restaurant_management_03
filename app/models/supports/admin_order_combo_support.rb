module Supports
  class AdminOrderComboSupport
    def needing_combos
      OrderCombo.needing.sort_by(&:cooking_time)
    end

    def cooking_combos
      OrderCombo.cooking.sort_by(&:cooking_time)
    end

    def done_combos
      OrderCombo.cooked
    end

    def cancel_combos
      OrderCombo.cancel
    end
  end
end
