class GalleryCommentsController < ApplicationController

  before_filter :in_photos_section

  # Creates a new blog comment
  def create
    @gallery_comment = GalleryComment.new(params[:gallery_comment])
   
    if @gallery_comment.save
      flash[:notice] = 'Saved gallery comment.';
    else
      flash[:error] = 'Failed to save gallery comment.' 
    end
    
    redirect_to :controller => 'galleries', :action => 'show', :id => @gallery_comment.gallery_id
  end
  
end
