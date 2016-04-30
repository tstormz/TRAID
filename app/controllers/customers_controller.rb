class CustomersController < ApplicationController
  
  before_action :find_transaction
  before_action :set_hashes, only: [:new, :search]
  
  def show
    @customers = Customer.sorted
  end
  
  def new
    @header = "Create a New Customer"
  end
  
  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      if @transaction
        redirect_to({:controller => 'transactions', :action => 'add_customer',
            :transaction_id => @transaction.id, :customer_id => @customer.id})
      else
        redirect_to({:action => 'show'})
      end
    end
  end
  
  def search
    @header = "Search for Existing Customer"
  end
  
  def results
    @header = "Select a Customer for Transaction"
    @results = Array.new
    @search_terms = Array.new
    customer_params.each do |field,keyword|
      unless keyword.empty?
        Customer.search(field,keyword).each do |customer|
          if (i = @results.index(customer)) != nil
            @results.prepend(@results.delete_at(i))
          else
            @results << customer
          end
          @search_terms << keyword
        end
      end
    end
  end
  
  def process_request
    if params[:search_again]
      redirect_to(:action => 'search', :transaction_id => @transaction.id)
    else
      hash = {:controller => 'transactions'}
      hash = hash.merge({:action => 'add_customer'})
      hash = hash.merge({:transaction_id => @transaction.id})
      redirect_to(hash.merge({:customer_id => params[:customer_id]}))
    end
  end
  
  def delete
    
  end
  
  private
  
  def find_transaction
    if params[:transaction_id]
      @transaction = Transaction.find(params[:transaction_id])
    end
  end
  
  def customer_params
    params.require(:customer).permit(:first_name, :last_name)
  end
  
  def set_hashes
    if @transaction
      @tid_hash = {:transaction_id => @transaction.id}
      @return_hash = {:controller => 'transactions', :action => 'delete',
        :transaction_id => @transaction.id}
    else
      @tid_hash = {}
      @return_hash = {:controller => 'menu', :action => 'index'}
    end
  end
  
end
