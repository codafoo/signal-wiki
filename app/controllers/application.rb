# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  require 'redcloth'
  include AuthenticatedSystem

  before_filter :find_site
  helper_method  :site
  attr_reader    :site
  
  def find_site
    @site ||= Site.find(:first)
  end
  
  def require_admin
    redirect_to(page_path('home')) unless admin?
  end
  
end
