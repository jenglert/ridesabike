class BlogPost < ActiveRecord::Base
  belongs_to :user
  has_many :blog_comments
  
end
