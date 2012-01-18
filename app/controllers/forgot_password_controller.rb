class ForgotPasswordController < ApplicationController
  
  def index
  end

  def create
    email = params[:email]
    
    user = User.find_by_email(email)
    
    if(!user.nil?)
      EmailMessages.deliver_forgot_password(user.id)
    end
  end
  
end
