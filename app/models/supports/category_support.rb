module Supports
  class CategorySupport
    attr_reader :categories, :param

    def initialize arg
      @categories = arg[:categories]
      @param = arg[:param]
    end

    def categories_search
      search.result.page(param[:page]).per_page Settings.limit
    end

    def search
      search = Category.ransack param[:q]
      search.sorts = %w(created_at desc name) if search.sorts.empty?
      search
    end
  end
end
