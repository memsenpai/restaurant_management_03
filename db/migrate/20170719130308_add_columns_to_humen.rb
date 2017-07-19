class AddColumnsToHumen < ActiveRecord::Migration[5.0]
  def change
    add_column :humen, :phone_num, :string
    add_column :humen, :password_digest, :string
    add_column :humen, :admin_role, :integer
    add_column :humen, :code, :integer
  end
end
