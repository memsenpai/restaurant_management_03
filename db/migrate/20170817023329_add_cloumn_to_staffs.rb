class AddCloumnToStaffs < ActiveRecord::Migration[5.0]
  def change
    add_column :staffs, :deleted, :boolean, default: false
  end
end
