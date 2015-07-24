class RemoveTypeFromTag < ActiveRecord::Migration
  def change
    remove_column :tags, :type
  end
end
