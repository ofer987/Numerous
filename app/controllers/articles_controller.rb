class ArticlesController < ApplicationController
  skip_before_action :authorize, only: [:index, :show]
  
  # Negative captcha
  before_action :setup_comment_negative_captcha, only: :show
  
  def index
    @articles = Article.all.paginate(page: selected_page)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end
  
  def show
    @article = Article.find_by_id(params[:id])
    @edit_mode = false
    
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
      format.html { redirect_to articles_url }
      format.json { head :ok }
    end
  end

  def new
    @article = Article.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end
  
  def edit
    @article = Article.find(params[:id])
    @edit_mode = true
    
    render file: 'articles/edit.js'
  end

  def create
    @article = Article.new(article_params)
    
    respond_to do |format|
      # Save the article first and then the dependent associations
      if @article.save
        format.html { redirect_to article_path(@article) }
        format.json { render json: @article, status: :created, location: @article }
      else
        # Save failed
        format.html { redirect_to new_article_path }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def create_photo
    @article = Article.find_by_id(params[:article_id])    
    @photo = @article.photos.create(load_photo_file: photo_params[:load_photo_file])

    if @photo and @photo.valid?
      render file: 'articles/create_photo.js'
    else
      render file: 'article/upload_file_error.js', locals: { notice: "Error uploading file" }
    end
  end  
  
  def update
    @article = Article.find(params[:id])
    
    @article.attributes = article_params
    respond_to do |format|
      if @article.save
        format.html { redirect_to article_path(@article) }
        format.json { head :ok }
      else
        format.html { redirect_to edit_article_path(@article) }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  
  def selected_page
    params[:page]
  end
  
  def photo_params
    params.require(:photo).permit(:load_photo_file)
  end
  
  def article_params
    # maybe should be article_photos_attributes instead of article_photos
    params.require(:article).permit(:title, :sub_title, :content, :published_at, 
      article_photos_attributes: [:is_selected, :id])
  end
  
  def setup_comment_negative_captcha
    @comment_captcha = RefusalCaptcha.new(
      secret: Numerous::Application.config.negative_captcha_secret,
      spinner: request.remote_ip,
      fields: [:content, :user],
      params: params
      )
  end
end