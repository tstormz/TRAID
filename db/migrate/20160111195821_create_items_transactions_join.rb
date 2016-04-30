class CreateItemsTransactionsJoin < ActiveRecord::Migration
  def change
    create_table :items_transactions, :id => false do |t|
      t.integer "item_id"
      t.integer "transaction_id"
    end
    add_index :items_transactions, ["item_id", "transaction_id"]
  end
end
