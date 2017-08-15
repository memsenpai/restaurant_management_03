class Membership < ApplicationRecord
  belongs_to :customer

  def ratio
    MembershipLevel.ratio(vip? ? total_point * 2 : total_point * 1)
  end
end
