class MembershipLevel < ApplicationRecord
  scope :ratio, ->(point){where("point <= ?", point).maximum :ratio}
end
