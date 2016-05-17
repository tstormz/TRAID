class Customer < ActiveRecord::Base
  
  has_many :transactions
  
  scope :sorted, lambda { order("customers.last_name ASC, first_name ASC")}
  
  scope :search, lambda { |field, keyword|
    where("#{field} like ?", "%#{keyword}%")
  }
  
  scope :existing_customer, lambda { |last_name, first_name| 
    where("last_name=? and first_name=?", last_name, first_name)
  }
  
end
