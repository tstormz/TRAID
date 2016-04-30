class Customer < ActiveRecord::Base
  
  has_many :transactions
  
  scope :sorted, lambda { order("customers.last_name ASC, first_name ASC")}
  
  scope :search, lambda { |field, keyword|
    where("#{field} like ?", "%#{keyword}%")
  }
  
end
