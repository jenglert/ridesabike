class BikerViewController < ApplicationController

  def index
    # If we cannot find the name from the list of parameters
    if !request.subdomains.first.nil?
      @user = User.find_by_login(request.subdomains.first)
      if !@user.nil?
        params[:id] = @user.id
      end 
    else
      if !params[:id].nil?
        @user = User.find(params[:id])
      end
    end
    
    if @user.nil? and logged_in?
      @user = current_user
    end
  
    # If there was no id passed and the user is not logged in, go to the login page
    if @user.nil? or @user == :false
      redirect_to(:controller => 'account', :action => 'login') 
    end
  end
  
  def show
    begin
      if !params[:id].nil?
        @user = User.find(params[:id])
      end
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Unable to find user.'
      
      redirect_to '/'
      return
    end
    
    render :action => 'index'   
  end
 
end
