class FileUploadTestController < ApplicationController
  
  protect_from_forgery :only => [:create, :delete, :update]
  
  def index
    
  end
  
  # Ajaxy requests come in here with file uploads of images.
  def upload

      current_user_id = params[:current_user_id]
      print current_user_id
      filename = params[:Filename]
      print filename
      filedata = params[:Filedata]
      print filedata
      galleryname = params[:gallery_name]
      print galleryname

      # Construct the gallery if necessary
      gallery = Gallery.find_by_title(galleryname)
      if gallery.nil?
        gallery = Gallery.new
        gallery.title = galleryname
        gallery.person_id = current_user_id
        gallery.save
    end
    
    picture = Picture.new
    picture.picture_file_name = filename
    picture.picture_file_data = filedata
    picture.title = ""
    picture.person_id = current_user_id
    picture.gallery_id = gallery.id
    picture.save
     
  end
  
  def view
    
  end
  
end
