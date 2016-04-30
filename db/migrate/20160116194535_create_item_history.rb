class CreateItemHistory < ActiveRecord::Migration
  def change
    create_table :item_histories do |t|
      t.references :item
      t.integer "transaction_id"
      t.datetime "time_in"
      t.datetime "time_out"
    end
  end
end
