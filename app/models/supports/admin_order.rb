class Supports::AdminOrder
  attr_reader :data

  def initialize arg
    @data = arg
  end

  def load_data
    data
  end
end
