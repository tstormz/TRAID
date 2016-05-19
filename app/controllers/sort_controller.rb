class SortController < ApplicationController
  
  before_action :get_fields
  
  def index
    @selection = select_params
    cookies.delete :sort_sequence
    if params[:selection]
      @transactions = Transaction.search(parse_selection(@selection))
    else
      @transactions = Transaction.newest
    end
  end

  def show
    @selection = select_params
    if cookies[:sort_sequence]
      cookies[:sort_sequence] = "#{cookies[:sort_sequence]} #{params[:sort_by]}"
    else
      cookies[:sort_sequence] = params[:sort_by]
    end
    if params[:selection]
      @transactions = Transaction.search(parse_selection(@selection))
        .order_by(cookies[:sort_sequence].split(" "))
    else
      @transactions = Transaction.order_by(cookies[:sort_sequence].split(" "))
    end
  end
  
  def select
    @transaction_options = get_types
    @transaction_options.unshift("")
    @borrow_options = get_borrow_types
    @borrow_options.unshift("")
    @at_options = get_at_options
    @at_options.unshift("")
  end
  
  private
  
  def parse_selection (query_params)
    selection = []
    query = ""
    query_params.each do |p|
      unless p[1].blank?
        query += (query.empty?) ? "#{p[0]} = ?" : " or #{p[0]} = ?"
        selection << p[1]
      end
    end
    reported_params = params.permit(:reported, :not_reported)
    if reported_params[:reported] and reported_params[:not_reported].nil?
      query += (query.empty?) ? "reported = ?" : " OR reported = ?"
      selection << "true"
    elsif reported_params[:not_reported] and reported_params[:reported].nil?
      query += (query.empty?) ? "reported = ?" : " OR reported = ?"
      selection << "false"
    end
    if params[:date_method] == "Before"
      before = params[:before]
      date = DateTime.new(before[:year].to_i,before[:month].to_i,before[:day].to_i,23,23,59,'-0400')
      query += (query.empty?) ? "borrowed <= ?" : " AND borrowed <= ?"
      selection << date
    elsif params[:date_method] == "After"
      after = params[:after]
      date = DateTime.new(after[:year].to_i,after[:month].to_i,after[:day].to_i,23,23,59,'-0400')
      query += (query.empty?) ? "borrowed >= ?" : " AND borrowed >= ?"
      selection << date
    elsif params[:date_method] == "Between"
      before = params[:before]
      after = params[:after]
      before_date = DateTime.new(before[:year].to_i,before[:month].to_i,before[:day].to_i,23,23,59,'-0400')
      after_date = DateTime.new(after[:year].to_i,after[:month].to_i,after[:day].to_i,23,23,59,'-0400')
      query += (query.empty?) ? "borrowed BETWEEN ? AND ?" : " AND borrowed BETWEEN ? AND ?"
      selection << before_date
      selection << after_date
    end
    selection.unshift(query)
    return selection
  end
  
  def select_params
    params.permit(:transaction_type, :borrower_type, :purpose_of_at, :sheet_code)
  end
  
  def get_fields
    @fields = get_t_fields
  end
  
end
