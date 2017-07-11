class EditDescriptionDishes < ActiveRecord::Migration[5.0]
  def change
    change_column :dishes, :description, :text
  end
end
