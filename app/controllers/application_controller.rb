class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  private
  
  helper_method :code_to_label, :customer_link
  
  def get_t_fields
    return [['Id', 'id'], ['Date', 'updated_at'], ['Customer', 'customer_id'], ['Type', 'transaction_type'],
      ['Sheet Code', 'sheet_code'], ['Reported', 'reported']]
  end
    
  def get_types
    return [['Exchange', 'exc'],
      ['Recycle', 'rec'], 
      ['Open-ended Loan', 'oel'], 
      ['Public Awareness', 'paw'], 
      ['Decision-Making Loan', 'dml'], 
      ['Waiting for Repair/Funding', 'wfr'], 
      ['Short-term Need', 'stn'], 
      ['I&A Devices', 'iad'],
      ['I&A Funding', 'iaf'],
      ['I&A Related', 'iar'],
      ['Make Donation', 'mkd'],
      ['Training', 'tra'],
      ['Not Available', 'nav'],
      ['Professional Development', 'pro'],
      ['Other', 'oth']]
  end
  
  def get_borrow_types
    return [['Individual', 'individual'], ['Family', 'family'],
      ['Education', 'education'], ['Employment', 'employment'], ['Health/Rehab', 'health_rehab'],
      ['Community Living', 'community_living'], ['Technology', 'technology']]
  end
  
  def get_ucp_options
    return [['Yes', 'y'],['No','n'],['Employee','e']]
  end
  
  def get_at_options
    return [['Education', 'education'], ['Employment', 'employment'],
      ['Community Living', 'community_living'], ['IT/Telecommunications', 'it']]
  end
  
  def get_reason_options
    return [['Only afford AT through this program', '1'],
      ['Not available through other programs', '2'],
      ['Too complex or long to get AT through other programs', '3'],
      ['None of the above', '4'], ['Exempt', '5'], ['Did not respond to question', '6']]
  end
  
  def code_to_label(the_labels,code)
    send(the_labels).each do |types|
      if types[1] == code
        return types[0]
      end
    end
    return nil
  end
  
  def customer_link(customer)
    url = {:controller => 'transactions', :action => 'show', :page => '0'}
    name = "#{customer.first_name} #{customer.last_name}"
    return [name, url.merge({:customer_id => customer.id})]
  end
  
  def get_error_msg(code)
    if code == '0'
      return "The transaction this item is associated with contains more than one item."
    end
  end

end
