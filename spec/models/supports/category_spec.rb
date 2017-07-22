require "rails_helper"

RSpec.describe Supports::CategorySupport, type: :model do
  FactoryGirl.create_list :category, 10
  categories = Supports::CategorySupport.new categories: Category.all,
    param: {q: "a"}
  it{expect(categories.categories).to_not eq nil}
  it{expect(categories.categories_search).to_not eq nil}
end
