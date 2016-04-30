class CreateTransactions < ActiveRecord::Migration

  def up
    create_table :transactions do |t|
      t.references :customer
      t.string "sub_category"
      t.string "contact_name"
      t.string "borrower_type"
      t.integer "brochures_sent"
      t.string "ucp_customer"
      t.string "transaction_type"
      t.string "decision"
      t.string "purpose_of_at"
      t.string "reason_use_us"
      t.string "equipment_type"
      t.string "availability"
      t.string "sheet_code"
      t.datetime "borrowed"
      t.datetime "returned"
      t.string "satisfaction"
      t.string "quarter_reported"
      t.string "in_out"
      t.boolean "reported"
      t.timestamps
    end
    add_index :transactions, "customer_id"
  end
  
  def down
    drop_table :transactions
  end
  
end
