class AddDeviseToStaffs < ActiveRecord::Migration[5.0]
  def self.up
    create_table :staffs do |t|
      t.string :name
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.integer :staff_role

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.timestamps
    end

    add_index :staffs, :email,                unique: true
    add_index :staffs, :reset_password_token, unique: true
    # add_index :staffs, :confirmation_token,   unique: true
    # add_index :staffs, :unlock_token,         unique: true
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
