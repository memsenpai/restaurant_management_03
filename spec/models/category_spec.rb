require "rails_helper"

RSpec.describe Category, type: :model do
  describe "associations" do
    it{should have_many :category_dishes}
    it{should have_many(:dishes).through(:category_dishes).dependent :destroy}
  end

  describe "validate" do
    it{should validate_presence_of :name}
  end
end
