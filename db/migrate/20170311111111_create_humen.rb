class CreateHumen < ActiveRecord::Migration[5.0]
  def change
    create_table :humen do |table|
      table.string :name
      table.string :email
      table.string :role

      table.timestamps
    end
  end
end
