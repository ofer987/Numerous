class PhotosController < ApplicationController
  before_filter :init_variables
  
  skip_before_filter :authorize, only: [:index, :show]
  
  # GET /photos
  # GET /photos.json
  def index
    @photos = Photo.all(order: @sql_order)
    @all_tags = Tag.all(order: 'name DESC')
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @photos }
    end
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
    @photo = Photo.find(params[:id])
    @displayed_fichier = @photo.select_fichier('small')
    
    @selected_photos = Photo.all(order: @sql_order)
    
    @current_photo_index = @selected_photos.rindex(@photo)
    
    @is_first_photo = @current_photo_index == 0
    @is_last_photo = @current_photo_index == @selected_photos.count - 1
    
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
    params[:tags] = @photo.tags.map { |tag| tag.name }.join(", ")
  end

  # POST /photos
  # POST /photos.json
  def create
    @photo = Photo.new(params[:photo])
    
    add_tags_to_new_photo
    
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
      
    add_tags  
      
    respond_to do |format|
      if @photo.update_attributes(params[:photo])
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
    
  private
    
  def init_variables
    @sql_order = 'created_at DESC'
  end
  
  def add_tags
    debugger
    tags = params[:tags] || ""
    tag_names = tags.split(",")
    
    # Remove tags
    @photo.tags.each do |tag|
      if !tag_names.any? { |supplied_name| supplied_name.strip.downcase == tag.name.strip.downcase }
        @photo.tags.destroy(tag)
      end
    end
    
    # Add tags
    tag_names.each do |name|
      name = name.strip.downcase
      tag = Tag[name] || Tag.create(name: name)
      
      @photo.tags.find_by_name(name) || @photo.tags.push(tag)
    end
  end
  
  def add_tags_to_new_photo
    tags = params[:tags] || ""
    tag_names = tags.split(",")
    
    # Add tags
    tag_names.each do |name|
      name = name.strip.downcase
      tag = Tag[name] || Tag.create(name: name)

      @photo.photo_tags.build { |photo_tag| photo_tag.tag_id = tag.id }
    end
  end
end
