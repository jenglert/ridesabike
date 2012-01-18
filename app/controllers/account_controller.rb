class AccountController < ApplicationController
  
  before_filter :in_users_section
  
  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(:controller => '/biker_view', :action => 'index')
      flash[:notice] = "Logged in successfully."
      
      return
    end
    
    flash[:error] = "Failed to authenticate."
  end
  
  def signup
    
    @user = User.new(params[:user])
    return unless request.post?
    self.current_user = @user
    
    if ( @user.save! ) 
      self.current_user = @user
      flash[:notice] = "Thanks for signing up!"
      # Redirect the user to edit thier person.
      redirect_back_or_default(:controller => 'users', :action => 'edit', :id => @user.id)      
    end
    
  rescue ActiveRecord::RecordInvalid => invalid
    # Set the current_user
    self.current_user = :false
    render :action => 'signup'
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => 'home_page')
  end
  
  def edit
    
  end
end
