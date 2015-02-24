class ArticlesController < ApplicationController
  skip_before_action :authorize, only: [:index, :show]

  before_action :init_user

  # Negative captcha
  before_action :setup_comment_negative_captcha, only: :show

  def index
    @articles = @user.articles.paginate(page: selected_page)

    respond_to do |format|
      format.html # index.html.erb
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

    # facebooker

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
    @article = Article.new(article_params)
    @article.tags_attributes = tags_params

    # Save the article first and then the dependent associations
    if @article.save
      redirect_to user_article_path(@user, @article)
    else
      # Save failed
      redirect_to new_user_article_path(@user)
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
      render file: 'articles/show.js'
    else
      render file: 'articles/error.js', locals: { notice: "Error updating article" }
    end
  end

  private

  def init_user
    @user = User.find_by_id(params[:user_id])
  end

  def selected_page
    params[:page]
  end

  def photo_params
    params.require(:photo).permit(:load_photo_file)
  end

  def article_params
    # maybe should be article_photos_attributes instead of article_photos
    params.require(:article).permit(:user_id, :title, :sub_title,
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
      params: params
      )
  end

  def facebooker
    unless defined? @graph and not @graph.nil?
      binding.pry
      access_token = facebook_cookies["access_token"]
      binding.pry
      @graph = Koala::Facebook::API.new(access_token)
    end

    Facebooker.new @graph
  end

  def facebook_cookies
    @facebook_cookies ||= Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
  end
end
