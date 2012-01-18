require 'acts_as_ferret'
class CreateIndexesController < ApplicationController
  
  layout 'blank'
  
  # Creates the indexes
  def index
    
    outputText = ''
    
    if params[:password] == 'zepher'

      ActsAsFerret.rebuild_index 'shared'
      
      outputText += 'Index Complete.'
      
    else
      outputText += 'Incorrect Password.'
    end
    
    render :text => outputText
  end
end
