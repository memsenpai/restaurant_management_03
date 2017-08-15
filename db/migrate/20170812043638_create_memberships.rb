class CreateMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :memberships do |t|
      t.integer :customer_id
      t.integer :point, default: 0
      t.integer :total_point, default: 0
      t.integer :vip, default: false

      t.timestamps
    end
  end
end
