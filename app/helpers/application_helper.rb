# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def getThumbnail(image)
    image.gsub(".", "_thumbnail.");
  end
  
  # Renders a h1 tag with the title and sets the @title instance variable.  
  # Passes all additional options through to the content_tag creating the h1.
  def page_title(name, *params)
    @title = name
    content_tag('h1', name, *params)
  end
  
  # Returns the number of years between now and the specified date.
  def years_ago(date)
    dateDifference = DateTime.now - date
    results =Date.day_fraction_to_time(dateDifference)
    return results[0] / 24 / 365;
  end
  
end
