class PagesController < ApplicationController
  before_filter :require_login, :except => [:index, :show, :revision, :search]
  before_filter :login_required, :only => [:destroy]
  before_filter :require_admin, :only => [:lock]
  before_filter :check_private, :only => [:show, :revision]
  cache_sweeper :page_sweeper, :only => [:create, :update ]
  include HTMLDiff
  
  # GET /pages
  # GET /pages.xml
  def index
    @pages = site.pages.find(:all, :limit => 20, :order => "updated_at DESC")
    # todo: paginate
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pages }
    end
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    @page = site.pages.find_by_permalink(params[:id] || "home")
    if @page
      @version = @page.versions.find_by_version(@page.version)
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @page }
      end
    else
      session[:new_title] = params[:id]
      redirect_to new_page_url()
    end
  end
  
  def diff
    @page = site.pages.find_by_permalink(params[:id])
    @v1 = @page.versions.find_by_version(params[:v1])
    @v2 = @page.versions.find_by_version(params[:v2])
    @diff = htmldiff(@v2.body,@v1.body)
    respond_to do |format|
      format.html
    end
  end

  def revisions
    @page = site.pages.find_by_permalink(params[:id])
    @revisions = @page.versions
    respond_to do |format|
      format.html
    end
  end

  def revision
    @page = site.pages.find_by_permalink(params[:id])
    @version = @page.versions.find_by_version(params[:version])
    
    respond_to do |format|
      format.html { render :action => "show"}
    end
  end

  # GET /pages/new
  # GET /pages/new.xml
  def new
    @page = site.pages.new(:title => session[:new_title].to_s.gsub("-", " ").capitalize, :permalink => session[:new_title])
    @button_text = "Add this page"
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/1/edit
  def edit
    @page = site.pages.find_by_permalink(params[:id])
    @button_text = "Save this version"
  end

  # POST /pages
  # POST /pages.xml
  def create
    @page = site.pages.new(params[:page])
    @page.request = request
    @page.user_id = (logged_in? ? current_user.id : nil)

    respond_to do |format|
      if @page.save
        #flash[:notice] = 'Page was successfully created.'
        format.html { redirect_to(wiki_page_url(@page)) }
        format.xml  { render :xml => @page, :status => :created, :location => @page }
      else
        format.html { puts @page.errors.inspect; render :action => "new" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @page = site.pages.find_by_permalink(params[:id])
    @page.request = request
    @page.user_id = (logged_in? ? current_user.id : nil)
    
    respond_to do |format|
      if @page.update_attributes(params[:page])
        #flash[:notice] = 'Page was successfully updated.'
        format.html { redirect_to(wiki_page_url(@page)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  def rollback
    @page = site.pages.find_by_permalink(params[:id])
    @page.revert_to!(params[:version])
    expire_fragment("show_#{params[:id]}_0")
    expire_fragment("show_#{params[:id]}_#{params[:version]}")
    respond_to do |format|
      #flash[:notice] = "#{@page.title} was successfully rolled back to revision #{params[:version]}"
      format.html { redirect_to(wiki_page_url(@page)) }
      format.xml  { head :ok }
    end
  end

  def search
    @pages = site.pages.find_with_index("#{params[:query]}")
    respond_to do |format|
      format.html
      format.xml
      format.js
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page = site.pages.find_by_permalink(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to(pages_url) }
      format.xml  { head :ok }
    end
  end
  
  def lock
    @page = site.pages.find_by_permalink(params[:id])
    if @page.locked?
      @page.unlock
    else
      @page.lock
    end
    respond_to do |format|
      format.html { redirect_to(wiki_page_url(@page)) }
      format.xml  { head :ok }
    end
  end
  
  def check_private
    @page = site.pages.find_by_permalink(params[:id])
    return unless @page
    if @page.private_page
      login_required
    else 
      true
    end
  end
  
  #FIXME: Remove this and add a manual cache call for pages we want cached, in the show method.
  # def caching_allowed
  #   if @page
  #     ! @page.private_page
  #   end
  # end
  
  def require_login
    site.require_login_to_post ? login_required : true
  end
  
end
