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
  
  private
  
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
