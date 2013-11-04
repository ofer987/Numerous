class StoriesController < ApplicationController
  skip_before_action :authorize, only: []

  def files
    @article = Article.new
  end

  def upload
  end

  def new
    @article = Article.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end

  def create
    @article = Article.new(article_params)    
    
    respond_to do |format|
      # Save the article first and then the dependent associations
      if @article.save
        format.html { redirect_to @article }
        format.json { render json: @article, status: :created, location: @article }
      else
        # Save failed
        format.html { render 'new' }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  
  def article_params
    params.require(:article).permit(:gazette_id, :title, :sub_title, :content, :published_at, 
      photos_attributes: [
        load_photo_file: []
      ]
    )
  end
end
