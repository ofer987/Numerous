class StoriesController < ApplicationController
  skip_before_action :authorize, only: []

  def files
    @article = Article.new
  end

  def new_photo
    @article = Article.find_by_id(params[:article_id])
  end

  def new
    @article = Article.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end

  def create_photo
    @article = Article.find_by_id(params[:article_id])
    
    @photo = @article.photos.create(load_photo_file: photo_params[:load_photo_file])
    #article_photo = @article.article_photos.create(photo_id: @photo.id) 
  end
  
  def create_article
    @article = Article.new(article_params)    
    
    respond_to do |format|
      # Save the article first and then the dependent associations
      if @article.save
        format.html { redirect_to stories_new_photo_path(@article) }
        format.json { render json: @article, status: :created, location: @article }
      else
        # Save failed
        format.html { render 'new' }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
    
  def photo_params
    params.require(:photo).permit(:load_photo_file)
  end
  
  def article_params
    params.require(:article).permit(:gazette_id, :title, :sub_title, :content, :published_at)
  end
end
