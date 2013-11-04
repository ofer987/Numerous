class ArticlesController < ApplicationController
  skip_before_action :authorize, only: [:index, :show]
  
  def index
    @articles = Article.where(gazette_id: params[:gazette_id]).order("published_at desc")
    
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
    @article = Article.new(article_params)
    @article.gazette_id = params[:gazette_id]
    
    respond_to do |format|
      # Save the article first and then the dependent associations
      if @article.save
        format.html { redirect_to gazette_article_path(@article.gazette_id, @article) }
        format.json { render json: @article, status: :created, location: @article }
      else
        # Save failed
        format.html { redirect_to new_gazette_article_path(params[:gazette_id]) }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @article = Article.find(params[:id])
    
    @article.attributes = article_params
 
    respond_to do |format|
      if @article.save
        format.html { redirect_to gazette_article_path(@article.gazette_id, @article) }
        format.json { head :ok }
      else
        format.html { redirect_to edit_gazette_article_path(@article.gazette_id, @article) }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  
  def article_params
    # maybe should be article_photos_attributes instead of article_photos
    params.require(:article).permit(:gazette_id, :title, :sub_title, :content, :published_at, article_photos: [:is_selected, :id])
  end
end