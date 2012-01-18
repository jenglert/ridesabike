require 'RMagick'
require 'ftools'
class Bike < ActiveRecord::Base
  belongs_to :person
  
  # run write_file before save to db
  after_save :write_file
  
  # setter for form file field profile_image 
  # grabs the data and sets it to an instance variable.
  # we need this so the model is in db before file save,
  # so we can use the model id as filename.
  def bike_image=(file_data)
    @file_data = file_data
  end
  
  
  # write the @file_data data content to disk,
  def write_file
    
    #only process the file data if it is not null and not a String.
    if !(@file_data.nil?) and @file_data.type != String
      File.open("#{BIKE_IMAGE_FILE_PATH}#{id}.#{extension}", "w") { |file| file.write(@file_data.read) }
      print "#{BIKE_IMAGE_FILE_PATH}#{id}.#{extension}"
      image = Magick::ImageList.new("#{BIKE_IMAGE_FILE_PATH}#{id}.#{extension}")
      image.resize_to_fit!(200,200)
      image.write "#{BIKE_IMAGE_FILE_PATH}#{id}_thumbnail.#{extension}"
      self.thumbnail = "#{BIKE_IMAGE_URL_PATH}#{id}_thumbnail.#{extension}"
      self.imageURL= "#{BIKE_IMAGE_URL_PATH}#{id}.#{extension}"
      
      @file_data = nil;
      self.save
    end
  end
  
  # just gets the extension of uploaded file
  def extension
    @file_data.original_filename.split(".").last
  end
  
end
