class ChangeStatusMembersip < ActiveRecord::Migration[5.0]
  def change
    change_column :membership_coupons, :status, :integer, default: 0
  end
end
