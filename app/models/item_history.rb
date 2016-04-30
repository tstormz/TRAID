class ItemHistory < ActiveRecord::Base

  belongs_to :items
  
  scope :get_history, lambda { |item|
    where("item_id=#{item}").order("time_out DESC")
  }
  
  scope :get_transaction_history, lambda { |item, id|
    find_by_sql("select * from item_histories
      where item_id=#{item} and transaction_id=#{id}
      order by time_out DESC")
    }

end
