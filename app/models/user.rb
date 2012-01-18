require "ftools" 
require 'digest/sha1'
class User < ActiveRecord::Base
       
  has_many :bikes
  has_many :blog_posts
  has_many :galleries
  
  # run write_file before save to db
  before_save :do_before_save
  
  # setter for form file field profile_image 
  # grabs the data and sets it to an instance variable.
  # we need this so the model is in db before file save,
  # so we can use the model id as filename.
  def profile_image=(file_data)
    @file_data = file_data
  end
  
  
  # write the @file_data data content to disk,
  def write_file
    #only process the file data if it is not null and not a String.
    if !(@file_data.nil?) and @file_data.type != String
      File.open("#{PROFILE_IMAGE_FILE_PATH}#{id}.#{extension}", "w") { |file| file.write(@file_data.read) }
      
      # Resize the image to 150x150 at maximum.
      image = Magick::ImageList.new("#{PROFILE_IMAGE_FILE_PATH}#{id}.#{extension}")
      image.resize_to_fit!(150,150)      
      image.write "#{PROFILE_IMAGE_FILE_PATH}#{id}.#{extension}"
      
      self.imageURL= "#{PROFILE_IMAGE_URL_PATH}/#{id}.#{extension}"
    end
  end
  
  # just gets the extension of uploaded file
  def extension
    @file_data.original_filename.split(".").last
  end
   
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_format_of       :email, :with => /^.*@.*$/
  validates_format_of       :years_riding, :with => /^[0-9]*$/
  validates_uniqueness_of   :login, :email, :case_sensitive => false

 def do_before_save
   write_file
   encrypt_password
 end
 
  # Resets the user's password to their login.
  def reset_password() 
    self.password_confirmation = self.password = self.login
    
    self.save
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  # protected methods
  protected
  
  # before filter 
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.crypted_password = encrypt(password)
  end
  
  def password_required?
    crypted_password.blank? || !password.blank?
  end
end
