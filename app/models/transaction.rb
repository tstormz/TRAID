class Transaction < ActiveRecord::Base
  
  belongs_to :customer
  has_and_belongs_to_many :items
  
  scope :newest, lambda { order("updated_at DESC") }
  
  scope :by_customer, lambda { |c|
    Transaction.where("customer_id=#{c}").order("created_at DESC")
  }
  
  scope :read_view, lambda { |view|
    Transaction.find_by_sql("select * from #{view} order by customer_id DESC")
  }
  
  scope :order_by, lambda { |sequence|
    t = Transaction
    sequence.each do |s|
      if s == "item_type"
        t = t.joins(:items).uniq
      end
      t = t.order(s)
    end
    return t
  }
  
  scope :search, lambda { |selection|
    where(selection)
  }
  
end
