class BlogPostsController < ApplicationController
  
  before_filter :login_required, :except => [:index, :show, :by_user]
  before_filter :in_blog_posts_section
  
  # GET /blog_posts
  # GET /blog_posts.xml
  def index
    @blog_posts = BlogPost.find(:all).reverse
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :action => 'latest_blog_posts', :layout => false }
    end
  end

  # GET /blog_posts/1
  # GET /blog_posts/1.xml
  def show
    @blog_post = BlogPost.find(params[:id])
  end

  # GET /blog_posts/new
  # GET /blog_posts/new.xml
  def new
    @blog_post = BlogPost.new
  end

  # GET /blog_posts/1/edit
  def edit
    @blog_post = BlogPost.find(params[:id])
  end

  # POST /blog_posts
  # POST /blog_posts.xml
  def create
    @blog_post = BlogPost.new(params[:blog_post])
    
    @blog_post.user_id = current_user.id

    respond_to do |format|
      if @blog_post.save
        flash[:notice] = 'BlogPost was successfully created.'
        format.html { redirect_to(:controller => 'biker_view', :action=> 'index') }
        format.xml  { render :xml => @blog_post, :status => :created, :location => @blog_post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @blog_post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /blog_posts/1
  # PUT /blog_posts/1.xml
  def update
    @blog_post = BlogPost.find(params[:id])

    respond_to do |format|
      if @blog_post.update_attributes(params[:blog_post])
        flash[:notice] = 'BlogPost was successfully updated.'
        format.html { redirect_to(@blog_post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @blog_post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /blog_posts/1
  # DELETE /blog_posts/1.xml
  def destroy
    @blog_post = BlogPost.find(params[:id])
    @blog_post.destroy

    respond_to do |format|
      format.html { redirect_to(blog_posts_url) }
      format.xml  { head :ok }
    end
  end
  
  def by_user
    @blog_posts = BlogPost.find_all_by_user_id(params[:id])
    render :action => 'index'
  end
end
