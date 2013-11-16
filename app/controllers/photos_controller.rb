class PhotosController < ApplicationController
  before_action :init_variables
  
  # Negative captcha
  before_action :setup_comment_negative_captcha, only: :show
  
  skip_before_action :authorize, only: [:index, :show]
  
  # GET /photos
  # GET /photos.json
  def index
    @photos = Photo.order(@sql_order)
    @all_tags = Tag.order('name ASC')

    @selected_tag_name = params[:tag]
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @photos }
    end
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
    @photo = Photo.find(params[:id])
    @displayed_fichier = @photo.small_fichier
    
    if @displayed_fichier == nil
      redirect_to '/photos' 
      return
    end
    
    @photos = Photo.order(@sql_order)
    
    @current_photo_index = @photos.rindex(@photo)
    
    @is_first_photo = @current_photo_index == 0
    @is_last_photo = @current_photo_index == @photos.count - 1
    
    # new comment
    @comment = @photo.comments.new
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @photo }
    end
  end

  # GET /photos/new
  # GET /photos/new.json
  def new
    @photo = Photo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @photo }
    end
  end

  # GET /photos/1/edit
  def edit
    @photo = Photo.find(params[:id])
  end

  # POST /photos
  # POST /photos.json
  def create
    @photo = Photo.new(photo_params)
    @photo.new_tags = params[:new_tags]
    
    respond_to do |format|
      if @photo.save
        format.html { redirect_to photo_url(@photo), notice: 'Photo was successfully created.' }
        format.json { render json: @photo, status: :created, location: @photo }
      else
        format.html { render action: "new" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /photos/1
  # PUT /photos/1.json
  def update
    @photo = Photo.find(params[:id])  
    
    @photo.attributes = photo_params
    @photo.new_tags = params[:new_tags]
    
    respond_to do |format|
      if @photo.save
        format.html { redirect_to photo_url(@photo), notice: 'Photo was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
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
      format.json { head :ok }
    end
  end
  
  def rotate_clockwise
    @photo = Photo.find(params[:id])
    @photo.rotate!
    
    redirect_to @photo
  end
    
  private
    
  def init_variables
    @sql_order = 'taken_date DESC'
  end
  
  def photo_params
    params.require(:photo).permit(:id, :title, :description, :load_photo_file, tags_attributes: [:is_selected, :id])
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