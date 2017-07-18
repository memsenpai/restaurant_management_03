class Guest < Human
  include Encode
  has_many :orders, dependent: :destroy
  has_many :bills

  after_save :generate_code
end
