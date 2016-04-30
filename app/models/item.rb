class Item < ActiveRecord::Base

  has_and_belongs_to_many :all_transactions, class_name: "Transaction"
  has_many :item_histories
  
  scope :sorted, lambda { order("items.name ASC")}
  
  scope :is_available, lambda { where("available", "true") }
  
  scope :search, lambda { |field, keyword|
    where("#{field} like ?", "%#{keyword}%")
  }

end
