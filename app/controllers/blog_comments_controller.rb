class BlogCommentsController < ApplicationController
  
  before_filter :in_blog_posts_section
  
  # Creates a new blog comment
  def create
    @blog_comment = BlogComment.new(params[:blog_comment])
   
    if @blog_comment.save
      flash[:notice] = 'Saved blog comment.';
    else
      flash[:error] = 'Failed to save blog comment.' 
    end
    
    respond_to do |format|
        format.html { redirect_to :controller => 'blog_posts', :action => 'show', :id => @blog_comment.blog_post_id }
    end
  end
end
