module Encode
  def generate_code
    update_attributes code: Faker::Code.asin[4..-1] unless code
  end
end
