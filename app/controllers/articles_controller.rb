class ArticlesController < ApplicationController
  skip_before_filter :authorize, only: [:index]
  
  def index
    @articles = Article.find_all_by_gazette_id(params[:gazette_id])
    @is_authenticated = User.find_by_id(session[:user_id]) != nil
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end
  
  def show
    @article = Article.find_by_id(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end
  end
  
  def destroy
    @article = Article.find(params[:id])
    begin
      @article.destroy
      flash[:notice] = "article (#{@article.title}) was deleted"
    rescue Exception => e
      flash[:notice] = e.message
    end
    
    respond_to do |format|
      format.html { redirect_to gazette_articles_url(params[:gazette_id]) }
      format.json { head :ok }
    end
  end

  def new
    @article = Article.new
    @gazette = Gazette.find_by_id(params[:gazette_id])
    @all_photos = Photo.all
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end
  
  def edit
    @article = Article.find(params[:id])
    @gazette = Gazette.find(params[:gazette_id])
    @all_photos = Photo.all
  end
  
  def create
    @article = Article.new(params[:article])
    @article.gazette_id = params[:gazette_id]
  
    respond_to do |format|
      if @article.save
        format.html { redirect_to gazette_article_path(@article.gazette_id, @article) }
        format.json { render json: @article, status: :created, location: @article }
      else
        format.html { render action: "new" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @article = Article.find(params[:id])

    params.select { |param| param.start_with? 'photo' }.each do |param|
      photo_id = param[1]
      @article.article_photos.build { |article_photo| article_photo.photo_id = photo_id }
    end
 
    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to gazette_article_path(@article.gazette_id, @article) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end
end