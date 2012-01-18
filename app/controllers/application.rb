# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
   
  layout 'standard'
  
  # Hightlight the users section
  def in_users_section
    @currentSection = 'users'
  end

  def is_iphone_browser
    request.user_agent =~ /(Mobile\/.+Safari)/
  end
  
  # Hightlight the blog posts sections
  def in_blog_posts_section
    @currentSection = 'blogPosts'
  end
  
  # Hightlight the photos section
  def in_photos_section
    @currentSection = 'photos'
  end
  
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
  before_filter :record_performance_metrics_start
  after_filter :record_performance_metrics_end

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => 'a9353e02111d14b680994d3ba66de4ca'

  def record_performance_metrics_start
    params['REQUEST_START_TIME'] = Time.new.usec
  end
  
  def record_performance_metrics_end
    pMetrics = PerformanceMetric.new   
    pMetrics.referrer = request.env
    pMetrics.url = request.path
    pMetrics.source = request.remote_ip
    pMetrics.page_load_time = Time.new.usec - params['REQUEST_START_TIME']
    pMetrics.save!
  end

end
