class AddPublicToTags < ActiveRecord::Migration
  def change
    add_column :tags, :public, :boolean
  end
end
