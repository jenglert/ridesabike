require 'RMagick'
require 'ftools'
class Picture < ActiveRecord::Base
   
   belongs_to :gallery
  
  # run write_file before save to db
  after_save :write_file
  
  def picture_file_name=(file_name)
    @file_name = file_name
  end
  
  def picture_file_data=(file_data)
    @file_data = file_data
  end
  
  def write_file
    #only process the file data if it is not null and not a String.
    if !(@file_data.nil?) and @file_data.type != String
      File.open("#{PICTURES_IMAGE_FILE_PATH}#{id}.#{extension}", "w") { |file| file.write(@file_data.read) }
      print "#{PICTURES_IMAGE_FILE_PATH}#{id}.#{extension}"
      image = Magick::ImageList.new("#{PICTURES_IMAGE_FILE_PATH}#{id}.#{extension}")
      image.resize_to_fit!(200,200)
      image.write "#{PICTURES_IMAGE_FILE_PATH}#{id}_thumbnail.#{extension}"
      
      image = Magick::ImageList.new("#{PICTURES_IMAGE_FILE_PATH}#{id}.#{extension}")
      image.resize_to_fit!(800,800)      
      image.write "#{PICTURES_IMAGE_FILE_PATH}#{id}_med.#{extension}"
      
      self.thumbnail = "#{PICTURES_IMAGE_URL_PATH}#{id}_thumbnail.#{extension}"
      self.imageURL= "#{PICTURES_IMAGE_URL_PATH}#{id}.#{extension}"
      self.mid_size_image = "#{PICTURES_IMAGE_URL_PATH}#{id}_med.#{extension}"
      
      @file_data = nil;
      self.save
    end
  end
  
    # just gets the extension of uploaded file
  def extension
    @file_data.original_filename.split(".").last
  end
end
