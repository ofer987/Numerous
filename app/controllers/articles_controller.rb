class ArticlesController < ApplicationController
  skip_before_filter :authorize, only: [:index, :show]
  
  def index
    @articles = Article.find_all_by_gazette_id(params[:gazette_id])
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end
  
  def show
    @article = Article.find_by_id(params[:id])
    
    # New comment
    # Note: we do not know for which article this comment should be.
    @comment = Comment.new
    
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
    if params[:is_convert_to_html] == "1"
      params[:article][:content] = params[:article][:content].to_html
    end
    
    @article = Article.new(params[:article])
    @article.gazette_id = params[:gazette_id]
    
    respond_to do |format|
      # Save the article first and then the dependent associations
      if @article.save
        @article.photos_attributes = params[:article][:photos_attributes]
        if @article.save
          format.html { redirect_to gazette_article_path(@article.gazette_id, @article) }
          format.json { render json: @article, status: :created, location: @article }
        end
      end
      
      # Save failed
      @all_photos = Photo.all
      format.html { render new_gazette_article_path(params[:gazette_id]) }
      format.json { render json: @article.errors, status: :unprocessable_entity }
    end
  end
  
  def update
    @article = Article.find(params[:id])
    
    if params[:is_convert_to_html] == "1"
      params[:article][:content] = params[:article][:content].to_html
    end
    
    @article.attributes = params[:article] 
    @article.photos_attributes = params[:article][:photos_attributes]
 
    respond_to do |format|
      if @article.save
        format.html { redirect_to gazette_article_path(@article.gazette_id, @article) }
        format.json { head :ok }
      else
        @all_photos = Photo.all
        format.html { redirect_to edit_gazette_article_path(@article.gazette_id, @article) }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  
  def remove_photos
    article_photos = params[:article][:article_photos_attributes] ? params[:article][:article_photos_attributes] : Hash.new
    
    article_photos.each do |index, article_photo|
      @article.article_photos.where(photo_id: article_photo[:id].to_i).destroy_all if article_photo[:is_selected] == "0"
    end
  end
  
  def add_photos
    article_photos = params[:article][:article_photos_attributes] ? params[:article][:article_photos_attributes] : Hash.new
    
    article_photos.each do |index, article_photo|
      if article_photo[:is_selected] == "1" && !@article.article_photos.where(photo_id: article_photo[:id].to_i).any?
        @article.article_photos.build(photo_id: article_photo[:id].to_i)
      end
    end
  end
end