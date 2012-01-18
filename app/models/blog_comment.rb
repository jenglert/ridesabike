class BlogComment < ActiveRecord::Base
  
  belongs_to :blog_post
  
  validates_presence_of(:title, :body, :owner)
  
  def helpers
    ActionController::Base.helpers 
  end

end
