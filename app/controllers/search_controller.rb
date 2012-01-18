class SearchController < ApplicationController
  
  # Process search
  def index
    
    outputText = ''
  
    searchTerm = params[:q]
    
    @results = ActsAsFerret.find(searchTerm, 'shared')
    
 #   outputText += ActsAsFerret.methods.collect { |method| method + '<br />'}.to_s + '<br />'
    
    outputText += 'Found ' + @results.size.to_s + ' results.<br />'
    
    @results.each { |result|
      outputText += dom_class(result).to_s + result.id.to_s  
    }
  end
end
