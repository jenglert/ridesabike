class EmailMessages < ActionMailer::Base

  def forgot_password(user_id)
    user = User.find(user_id);
    user.reset_password
    
    recipients user.email
    subject 'Ridesabike.com forgot password'
    from 'webmaster@ridesabike.com'
    content_type 'text/html'
    
    body :user => user
  end

end
