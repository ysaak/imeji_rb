class AddGroupRefToTags < ActiveRecord::Migration
  def change
    add_reference :tags, :group, index: true, :null => false, :default => 1
  end
end
