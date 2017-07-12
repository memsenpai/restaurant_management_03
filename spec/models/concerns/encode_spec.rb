require "rails_helper"
include Encode

RSpec.describe "test encode" do
  it{expect(encode 1).to_not be == 1}
end
