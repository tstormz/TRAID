class TransactionsController < ApplicationController
  
  before_action :find_transaction, except: [:new, :show, :get_customer]
  
  def new
    @header = "New Transaction"
    @types = get_types
  end
  
  def get_customer
    transaction = Transaction.create(:transaction_type => params[:type])
    path = {:controller => 'customers', :transaction_id => transaction.id}
    if params[:customer] == "existing"
      redirect_to(path.merge({:action => 'search'}))
    else
      redirect_to(path.merge({:action => 'new'}))
    end
  end
  
  def add_customer
    @customer = Customer.find(params[:customer_id])
    @customer.transactions << @transaction
    redirect_to({:action => 'add_items', :transaction_id => @transaction.id})
  end
  
  def add_items
    @header = "Search for Items to Add"
  end
  
  def select_items
    @header = "Select Items to Add"
    @results = Array.new
    @search_terms = Array.new
    item_params.each do |field,keyword|
      unless keyword.empty?
        Item.search(field,keyword).each do |item|
          if (i = @results.index(item)) != nil
            @results.prepend(@results.delete_at(i))
          else
            @results << item
          end
          @search_terms << keyword
        end
      end
    end
  end
  
  def process_items
    unless params['items'].blank?
      params['items'].each do |item_id|
        item = Item.find(item_id)
        @transaction.items << item
        item.available = false
        history = ItemHistory.create(:time_out => DateTime.now, :transaction_id => @transaction.id)
        item.item_histories << history
        item.save
      end
    end
    redirect_to({:action => 'confirm_items', :transaction_id => @transaction.id})
  end
  
  def confirm_items
    @header = "Item Selection Confirmation"
  end
  
  def details
    @header = "Finish Transaction"
    @borrower_types = get_borrow_types
    @ucp_options = get_ucp_options
    @at_options = get_at_options
    @reason_options = get_reason_options
  end
  
  def create
    if @transaction.update_attributes(transaction_params)
#      redirect_to action: 'show', transaction_id: @transaction.id
      redirect_to({:controller => 'customers', :action => 'show'})
    end
  end
  
  def show
    @customer = Customer.find(params[:customer_id])
    if params[:page]
      @page = params[:page]
      @transaction = Transaction.by_customer(@customer.id)[@page.to_i]
      @status = Array.new
      @transaction.items.each do |item|
        history = ItemHistory.get_transaction_history(item.id, @transaction.id).first
        if history.time_in.nil?
          @status << "out since #{history.time_out}"
        else
          @status << "returned on #{history.time_in}"
        end
      end
    end
  end
  
  def delete
    @transaction.items.each do |item|
      item.available = true
      item.save
    end
    # perhaps I want destroy... uncertain at this point in time
    # also Google before_action
    @transaction = Transaction.destroy(params[:transaction_id])
  end
  
  private
  
  def find_transaction
    @transaction = Transaction.find(params[:transaction_id])
  end
  
  def transaction_params
    params.require(:transaction).permit(:contact_name, :borrower_type,
      :brochures_sent,:ucp_customer, :decision, :purpose_of_at, 
      :reason_use_us, :sheet_code, :borrowed, :reported)
  end
  
  def item_params
    params.permit(:name, :item_type)
  end
  
end
