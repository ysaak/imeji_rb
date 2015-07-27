class AddCategoryToTags < ActiveRecord::Migration
  def change
    add_column :tags, :category, :integer, null: false, default: 0
  end
end
