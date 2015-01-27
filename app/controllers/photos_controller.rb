class PhotosController < ApplicationController
  before_action :init_variables
  before_action :init_photo, only: [:show, :edit, :update]
  before_action :init_article

  # Negative captcha
  before_action :setup_comment_negative_captcha,
    only: [:show, :edit, :update]

  skip_before_action :authorize, only: [:index, :show]

  # GET /photos
  # GET /photos.json
  def index
    @photos = @article.photos
    @all_tags = Tag.all_tagable(Photo)

    @selected_tag_name = params[:tag]

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
    if @displayed_fichier.nil?
      redirect_to '/photos'
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @photo }
      format.js
    end
  end

  # GET /photos/new
  # GET /photos/new.json
  def new
    @photo = Photo.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /photos/1/edit
  def edit
    @edit_mode = true

    respond_to do |format|
      format.html # edit.html
    end
  end

  # POST /photos
  # POST /photos.json
  def create
    @photo = @article.photos.build(photo_params)

    respond_to do |format|
      if @photo.save
        format.html { redirect_to photo_url(@photo) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /photos/1
  # PUT /photos/1.json
  def update
    @photo = Photo.find(params[:id])

    @photo.attributes = photo_params

    respond_to do |format|
      if @photo.save
        @edit_mode = true
        format.js
      else
        format.js do
          # Failed to update photo, so keep update mode on
          @edit_mode = true
          render file: 'photos/update.js'
        end
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to photos_url }
    end
  end

  def rotate_clockwise
    @photo = Photo.find(params[:id])
    @photo.rotate!

    redirect_to @photo
  end

  private

  def init_variables
    @edit_mode = false
  end

  def init_photo
    @photo = Photo.find(params[:id])
    @displayed_fichier = @photo.small_fichier

    @photos = Photo.order(@sql_order)

    @current_photo_index = @photos.rindex(@photo)

    @is_first_photo = @current_photo_index == 0
    @is_last_photo = @current_photo_index == @photos.count - 1

    # new comment
    @comment = @photo.comments.new
  end

  def init_article
    @article = Article.find(params[:article_id])
  end

  def photo_params
    params.require(:photo).permit(:id, :title, :description, :load_photo_file, :tags_attributes, photo_tags_attributes: [:is_selected, :id])
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
