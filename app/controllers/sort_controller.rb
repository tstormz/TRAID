class SortController < ApplicationController
  
  before_action :get_fields
  
  def index
    cookies.delete :sort_sequence
    @transactions = Transaction.newest
  end

  def show
    if cookies[:sort_sequence]
      cookies[:sort_sequence] = "#{cookies[:sort_sequence]} #{params[:sort_by]}"
    else
      cookies[:sort_sequence] = params[:sort_by]
    end
    @transactions = Transaction.order_by(cookies[:sort_sequence].split(" "))
  end
  
  def select
    @transaction_options = get_types
    @transaction_options.unshift("")
    @borrow_options = get_borrow_types
    @borrow_options.unshift("")
    @at_options = get_at_options
    @at_options.unshift("")
  end
  
  def make_selection
    @selection = []
    select_params.each do |p|
      unless p.blank?
        Transaction.search(p[0], p[1]).each do |t|
          @selection << t
        end
      end
    end
    cookies.delete :sort_sequence
    @transactions = @selection.uniq
    render('index')
  end
  
  private
  
  def select_params
    params.permit(:transaction_type, :borrower_type, :purpose_of_at, :sheet_code)
  end
  
  def execute_statement(sql)
    results = ActiveRecord::Base.connection.execute(sql)
    if results.present?
      return results
    else
      return nil
    end
  end
  
  def create_view(field, value)
    execute_statement("create or replace view my_view as 
      select * from transactions where #{field}='#{value}'")
  end
  
  def get_fields
    @fields = get_t_fields
  end
  
end
