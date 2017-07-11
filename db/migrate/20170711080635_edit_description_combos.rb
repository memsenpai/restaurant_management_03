class EditDescriptionCombos < ActiveRecord::Migration[5.0]
  def change
    change_column :combos, :description, :text
  end
end
