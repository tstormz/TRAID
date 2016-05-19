class ItemsController < ApplicationController
  
  def new
  end
  
  def create
  end
  
  def search
    cookies.delete :item_list
  end
  
  def show
    if params[:search]
      @items = Array.new
      @search_terms = Array.new
      cookies[:item_list] = ""
      item_params.each do |field,keyword|
        unless keyword.empty?
          Item.search(field,keyword).each do |item|
            @items = add_item(@items,item)
            @search_terms << keyword
          end
          cookies[:item_list] += "#{field}::#{keyword}]["
        end
      end
      cookies[:item_list] = cookies[:item_list][0...-2] #cut trailing delimiter
    elsif params[:back]
      @items = get_my_items(cookies[:item_list])
    else
      @items = Item.sorted
    end
    @borrowers = Hash.new
    @items.each do |item|
      unless item.available
        borrower_list = Array.new
        item.all_transactions.each do |t|
          borrower_list << t
        end
        @borrowers[item.id] = borrower_list
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
  
  private
  
  def item_params
    params.permit(:name, :item_type)
  end
  
  def get_my_items(str)
    items = Array.new
    str.split("][").each do |tuple|
      item_args = tuple.split("::")
      Item.search(item_args[0],item_args[1]).each do |item|
        items = add_item(items,item)
      end
    end
    return items
  end
  
  def add_item(list,item)
    if (i = list.index(item)) != nil
      list.prepend(list.delete_at(i)) #remove and bump to top
    else
      list << item
    end
    return list
  end
  
end