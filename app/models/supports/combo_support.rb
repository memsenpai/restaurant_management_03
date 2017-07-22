module Supports
  class ComboSupport
    attr_reader :combos, :param

    def initialize arg
      @combos = arg[:combo]
      @param = arg[:param]
    end

    def combos_search
      search.result.page(param[:page]).per_page Settings.limit
    end

    def search
      search = Combo.ransack param[:q]
      search.sorts = %w(created_at desc name discount) if search.sorts.empty?
      search
    end
  end
end
