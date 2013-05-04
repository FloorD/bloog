class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :exhibits
  
  def blog_url(*) 
    root_url
  end
  
  before_filter :init_blog 
  private
    def init_blog 
      @blog = THE_BLOG
    end
  
end