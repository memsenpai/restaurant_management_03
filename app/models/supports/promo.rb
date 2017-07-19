class Supports::Promo
  attr_reader :promos, :param

  def initialize arg
    @promos = arg[:promos]
    @param = arg [:param]
  end

  def dishes
    promos.map(&:dish)
  end

  def promos_search
    search.result.page(param[:page]).per_page Settings.limit
  end

  def search
    search = Promo.ransack param[:q]
    search.sorts = %w(created_at desc name) if search.sorts.empty?
    search
  end
end
