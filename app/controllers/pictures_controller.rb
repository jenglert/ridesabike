class PicturesController < ApplicationController
  
  before_filter :login_required, :except => [:index, :show, :by_user]
  before_filter :in_photos_section
  
  # GET /pictures
  # GET /pictures.xml
  def index
    @pictures = Picture.find(:all)
    
    @title = 'Viewing Pictures'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pictures }
    end
  end

  # GET /pictures/1
  # GET /pictures/1.xml
  def show
    @picture = Picture.find(params[:id])
    @gallery = Gallery.find_by_id(@picture.gallery_id)
    
    @title = @picture.title
    
    render :action => 'show', :layout => @gallery.layout
  
  end

  # GET /pictures/new
  # GET /pictures/new.xml
  def new
    @pictures = Picture.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pictures }
    end
  end

  # GET /pictures/1/edit
  def edit
    @picture = Picture.find(params[:id])
    
    if current_user.nil? or current_user.id != @picture.user_id
      redirect_to(@picture)
    end
   

  end

  # POST /pictures
  # POST /pictures.xml
  def create
    @pictures = Picture.new(params[:pictures])

    respond_to do |format|
      if @pictures.save
        flash[:notice] = 'Pictures was successfully created.'
        format.html { redirect_to(@pictures) }
        format.xml  { render :xml => @pictures, :status => :created, :location => @pictures }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pictures.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pictures/1
  # PUT /pictures/1.xml
  def update
    @picture = Picture.find(params[:id])

    respond_to do |format|
      if @picture.update_attributes(params[:picture])
        flash[:notice] = 'Pictures was successfully updated.'
        format.html { redirect_to(:controller => 'galleries', :action => 'edit', :id => @picture.gallery_id) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @picture.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pictures/1
  # DELETE /pictures/1.xml
  def destroy
    @pictures = Picture.find(params[:id])
    @pictures.destroy

    respond_to do |format|
      format.html { redirect_to(pictures_url) }
      format.xml  { head :ok }
    end
  end
  
  def by_user
    @allpictures = Picture.find_all_by_user_id(params[:id])
    
    @pictures = []
    
    for picture in @allpictures
      if !Gallery.find(picture.gallery_id).private?
        @pictures << picture
      end
    end
    
    render :action => 'index'
  end
end
