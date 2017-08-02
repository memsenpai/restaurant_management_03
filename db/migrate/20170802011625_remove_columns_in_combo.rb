class RemoveColumnsInCombo < ActiveRecord::Migration[5.0]
  def change
    remove_column :combos, :from
    remove_column :combos, :to
  end
end
