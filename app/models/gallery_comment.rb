class GalleryComment < ActiveRecord::Base
  
  belongs_to :gallery
    
  def helpers
    ActionController::Base.helpers 
  end

end
