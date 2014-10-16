class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :pocket_id
      t.string :title
    end
  end
end
