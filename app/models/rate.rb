class Rate < ApplicationRecord
  belongs_to :rater, class_name: Customer.name
  belongs_to :rateable, polymorphic: true
end
