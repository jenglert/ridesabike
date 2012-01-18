require "set"
class GalleriesController < ApplicationController

  before_filter :login_required, :except => [:index, :show, :by_user]  
  before_filter :in_photos_section
  
  # GET /galleries
  # GET /galleries.xml
  def index
    @galleries = Gallery.find_all_by_private(:false)
    
    @galleries.sort! { |a,b| b.created_at<=>a.created_at }
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @galleries }
    end
  end
  
  def by_user
      @galleries = Gallery.find_all_by_private_and_user_id(:false, params[:id])
      
      @galleries.sort! { |a,b| b.created_at<=>a.created_at }
      
      render :action => 'index'
  end

  # GET /galleries/1
  # GET /galleries/1.xml
  def show
    @gallery = Gallery.find(params[:id])
    @pictures = Picture.find_all_by_gallery_id(@gallery.id)
    
    # Set the title
    @title = @gallery.title

    render :action => 'show', :layout => @gallery.layout

  end

  # GET /galleries/new
  # GET /galleries/new.xml
  def new
    @gallery = Gallery.new

    # The current logged in user will be creating this gallery
    @gallery.user_id = current_user.id
  end

  # GET /galleries/1/edit
  def edit
    @gallery = Gallery.find(params[:id])
    @pictures = Picture.find_all_by_gallery_id(@gallery.id)
    
  end

  # POST /galleries
  # POST /galleries.xml
  def create
    @gallery = Gallery.new(params[:gallery])

    respond_to do |format|
      if @gallery.save
        flash[:notice] = 'Gallery was successfully created.'
        format.html { redirect_to(@gallery) }
        format.xml  { render :xml => @gallery, :status => :created, :location => @gallery }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @gallery.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /galleries/1
  # PUT /galleries/1.xml
  def update
    @gallery = Gallery.find(params[:id])

    respond_to do |format|
      if @gallery.update_attributes(params[:gallery])
        flash[:notice] = 'Gallery was successfully updated.'
        format.html { redirect_to(@gallery) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @gallery.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /galleries/1
  # DELETE /galleries/1.xml
  def destroy
    @gallery = Gallery.find(params[:id])
    @gallery.destroy

    respond_to do |format|
      format.html { redirect_to(galleries_url) }
      format.xml  { head :ok }
    end
  end
end
