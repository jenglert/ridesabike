class Gallery < ActiveRecord::Base
  
  belongs_to :user
  has_many :pictures
  has_many :gallery_comments
  
end
