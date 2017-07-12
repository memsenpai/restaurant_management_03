require "rails_helper"

RSpec.describe CategoryDish, type: :model do
  describe "associations" do
    it{should belong_to :category}
    it{should belong_to :dish}
  end
end
