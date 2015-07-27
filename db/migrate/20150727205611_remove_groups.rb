class RemoveGroups < ActiveRecord::Migration
  def change
    remove_column :tags, :group_id
    drop_table :groups
  end
end
