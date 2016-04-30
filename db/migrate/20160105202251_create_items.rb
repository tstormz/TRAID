class CreateItems < ActiveRecord::Migration
  
  def up
    create_table :items do |t|
      
      t.string "name"
      t.boolean "available", default: true
      t.string "item_type"
      t.timestamps
    end
  end
  
  def down
    drop_table :items
  end
  
end
