class CustomersController < ApplicationController
  
  before_action :find_transaction
  before_action :set_hashes, only: [:new, :search]
  
  def show
    @customers = Customer.sorted
  end
  
  def new
    @header = "Create a New Customer"
    flash[:alert] = "<strong>Success!</strong> This box indicates a successful or positive action"
  end
  
  def create
    customer_info = customer_params
    customer = Customer.existing_customer(customer_info['last_name'], customer_info['first_name'])
    if customer.empty?
      @customer = Customer.new(customer_info)
      if @customer.save
        if @transaction
          redirect_to({:controller => 'transactions', :action => 'add_customer',
              :transaction_id => @transaction.id, :customer_id => @customer.id})
        else
          redirect_to({:action => 'show'})
        end
      end
    else
      flash[:alert] = "Existing customer: #{customer_info['first_name']} #{customer_info['last_name']}"
      redirect_to({:action => 'new'})
    end
  end
  
  def search
    @header = "Search for Existing Customer"
  end
  
  def find_customer
    @results = Array.new
    @search_terms = Array.new
    customer_params.each do |field,keyword|
      
    end
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
    if @transaction
      render('results')
    else
      render('find')
    end
  end
  
  def process_request
    if params[:search_again]
      redirect_to(:action => 'search', :transaction_id => @transaction.id)
    elsif params[:transaction_id]
      hash = {:controller => 'transactions'}
      hash = hash.merge({:action => 'add_customer'})
      hash = hash.merge({:transaction_id => @transaction.id})
      redirect_to(hash.merge({:customer_id => params[:customer_id]}))
    else
      redirect_to({:action => 'single', :customer_id => params[:customer_id]})
    end
  end
  
  def delete
    
  end
  
  def single
    @customer = Customer.find(params[:customer_id])
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
      @tid_hash = {:action => 'results', :transaction_id => @transaction.id}
      @return_hash = {:controller => 'transactions', :action => 'delete',
        :transaction_id => @transaction.id}
    else
      @tid_hash = {:action => 'results'}
      @return_hash = {:controller => 'menu', :action => 'index'}
    end
  end
  
end
