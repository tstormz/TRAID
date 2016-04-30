class MenuController < ApplicationController
  
  def index
    @header = "Main Menu"
  end
  
  def error
    @error_msg = get_error_msg(params[:error_code])
  end
  
end
