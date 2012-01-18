class FileUploadController < ApplicationController
  
  protect_from_forgery :only => [:create, :delete, :update]

  before_filter :login_required, :except => [:upload]
  
  before_filter :in_photos_section
  
  def index
    if(!params[:id].nil? and !Gallery.find_by_id(params[:id]).nil?)
      @gallery = Gallery.find_by_id(params[:id])
    else
      @gallery = Gallery.new(params[:gallery])  
    end

    @gallery.save
  end
  
  # Ajaxy requests come in here with file uploads of images.
  def upload

    current_user_id = params[:current_user_id]
    filename = params[:Filename]
    filedata = params[:Filedata]
    galleryname = params[:gallery_name]
    print galleryname

    # Construct the gallery if necessary
    gallery = Gallery.find_by_title(galleryname)
    if gallery.nil?
        gallery = Gallery.new
        gallery.title = galleryname
        gallery.user_id = current_user_id
        gallery.save
    end
    
    picture = Picture.new
    picture.picture_file_name = filename
    picture.picture_file_data = filedata
    picture.title = ""
    picture.user_id = current_user_id
    picture.gallery_id = gallery.id
    picture.save
     
  end
  
end