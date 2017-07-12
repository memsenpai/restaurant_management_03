require "rails_helper"

RSpec.describe ComboDish, type: :model do
  describe "association" do
    it{should belong_to :combo}
    it{should belong_to :dish}
  end
end
