class Supports::AdminDish
  attr_reader :dishes, :param

  def initialize arg
    @dishes = arg[:dish]
    @param = arg[:param]
  end

  def dishes_search
    search.result.page(param[:page]).per_page Settings.max_result
  end

  def search
    search = Dish.ransack param[:q]
    search.sorts = %w(id name price) if search.sorts.empty?
    search
  end
end
