class AddAuthenticationTokenToStaffs < ActiveRecord::Migration[5.0]
  def change
    add_column :staffs, :authentication_token, :string, limit: 30
    add_index :staffs, :authentication_token, unique: true
  end
end
