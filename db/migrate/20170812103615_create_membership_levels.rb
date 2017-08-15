class CreateMembershipLevels < ActiveRecord::Migration[5.0]
  def change
    create_table :membership_levels do |t|
      t.float :ratio, default: 1
      t.integer :point, default: 0

      t.timestamps
    end
  end
end
