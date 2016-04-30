class ItemsController < ApplicationController
  
  def new
  end
  
  def create
  end
  
  def search
  end
  
  def show
    @items = Item.sorted
    @borrowers = Hash.new
    @items.each do |item|
      unless item.available
        index = item.id
        borrower_list = Array.new
        item.all_transactions.each do |t|
          borrower_list << t.customer
        end
        @borrowers.merge({index => borrower_list})
      end
    end
  end
  
  def return_item
    item = Item.find(params[:item_id])
    item.available = true
    history = ItemHistory.get_history(item.id).first
    history.time_in = DateTime.now
    history.save
    item.save
    redirect_to(:action => 'show')
  end
  
  def create_items
    Item.create(:name=>"Thing 1", :item_type => "B")
    Item.create(:name=>"Thing 2", :item_type => "A")
    Item.create(:name=>"Thing 3", :item_type => "C")
    Item.create(:name=>"Thing 4", :item_type => "C")
    Item.create(:name=>"Thing 5", :item_type => "A")
    Item.create(:name=>"Thing 6", :item_type => "B")
    Item.create(:name=>"Thing 7", :item_type => "D")
    Item.create(:name=>"Thing 8", :item_type => "D")
    Item.create(:name=>"Thing 9", :item_type => "A")
    redirect_to(:action => "show")
  end
  
end
