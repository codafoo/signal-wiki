class PageSweeper < ActionController::Caching::Sweeper
  observe Page

  def after_save(record)
    expire_record(record.permalink,record.version)
    #expire_parent_links(record.permalink)
  end
  
  # def after_destroy(product)
  #   expire_record(record.permalink,record.version)
  # end
  
  def expire_record(permalink,version)
    RAILS_DEFAULT_LOGGER.info "Record to expire is: #{permalink} #{version}"
    expire_fragment("show_#{permalink}_#{version}")
    expire_fragment("show_#{permalink}_0")
    #expire_page("/#{permalink}")
  end

  # def expire_parent_links(permalink)
  #   wiki_word = permalink.split("-").join(" ")
  #   pages = Page.find_all_by_wiki_word(wiki_word)
  #   pages.each do |p| 
  #     expire_fragment("show_#{p.permalink}")
  #     RAILS_DEFAULT_LOGGER.info "Parent record to expire is: " + p.permalink.to_s
  #   end
  # end
  
end
