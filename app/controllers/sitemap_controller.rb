class SitemapController < ApplicationController
  layout 'blank'
  
  def index
    respond_to do |format|
      format.xml
    end
  end
  
end