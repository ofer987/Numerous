class ArticlesController < ApplicationController
  skip_before_action :authorize, only: [:index, :show]

  before_action :init_user

  # Negative captcha
  before_action :setup_comment_negative_captcha, only: :show

  def index
    @articles = @user.articles.find_by_tags(tag_names).paginate(page: selected_page)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @article = @user.articles.find_by_id(params[:id])
    @edit_mode = false

    # New comment
    # Note: we do not know for which article this comment should be.
    @comment = Comment.new

    respond_to do |format|
      format.html # show.html.erb
      format.js
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

    redirect_to user_articles_url(@user)
  end

  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @article = Article.find(params[:id])
    @all_photos = Photo.all
    @edit_mode = true

    respond_to do |format|
      format.html # edit.html
    end
  end

  def create
    @article = @user.articles.build(article_params)
    @article.tags_attributes = tags_params

    # Save the article first and then the dependent associations
    if @article.save
      redirect_to user_article_path(@user.username, @article)
    else
      # Save failed
      flash[:notice] = "Failure to save article because #{@article.errors.full_messages}"
      redirect_to new_user_article_path(@user.username)
    end
  end

  def create_photo
    @article = Article.find_by_id(params[:article_id])
    @photo = @article.photos.create(load_photo_file: photo_params[:load_photo_file])

    if @photo and @photo.valid?
      render file: 'articles/create_photo.js'
    else
      render file: 'articles/error.js', locals: { notice: "Error uploading file" }
    end
  end

  def update
    @article = Article.find(params[:id])

    @article.attributes = article_params
    if @article.save
      render file: 'articles/show.html'
    else
      render file: 'articles/error.html', locals: { notice: "Error updating article" }
    end
  end

  private

  def init_user
    @user = User.find_by_username(params[:username])
  end

  def tag_names
    (params[:tags] || '').split(',')
  end

  def selected_page
    params[:page]
  end

  def photo_params
    params.require(:photo).permit(:load_photo_file)
  end

  def article_params
    # maybe should be article_photos_attributes instead of article_photos
    params.require(:article).permit(:title, :sub_title,
                                    :content, :published_at,
      article_photos_attributes: [:is_selected, :id])
  end

  def tags_params
    params.require(:article).permit(:tags_attributes)
  end

  def setup_comment_negative_captcha
    @comment_captcha = RefusalCaptcha.new(
      secret: Numerous::Application.config.negative_captcha_secret,
      spinner: request.remote_ip,
      fields: [:content, :user],
      params: params)
  end
end
