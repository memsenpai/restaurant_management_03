class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :email
      t.string :phone_num
      t.string :code

      t.timestamps
    end
  end
end
