require "rails_helper"

RSpec.describe Supports::ComboSupport, type: :model do
  FactoryGirl.create_list :combo, 10
  combo = Supports::ComboSupport.new combo: Combo.all, param: {q: "a"}
  it{expect(combo.combos).to_not eq nil}
  it{expect(combo.combos_search).to_not eq nil}
end
