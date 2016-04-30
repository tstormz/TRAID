class ItemHistoriesController < ApplicationController
  
  def show
    @item = Item.find(params[:item_id])
    @history = ItemHistory.get_history(@item.id)
    @transactions = Array.new
    @history.each do |event|
      @transactions << Transaction.find(event.transaction_id)
    end
  end
  
end
