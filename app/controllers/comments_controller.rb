class CommentsController < ApplicationController
  before_filter :init_variables
  
  skip_before_filter :authorize

  # GET /comments
  # GET /comments.json
  def index
    @comments = @photo.comments

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = @photo.comments.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = @photo.comments.build(params[:comment])

    puts "Photo_id is #{@photo.id}\n"
    puts "Photo title is #{@photo.title}\n"
    puts "Hello: #{params[:comment]}\n"
    puts "New comment = #{@comment.attributes}\n"

    respond_to do |format|
      if @comment.save
        puts "able to save\n"
        format.html { redirect_to photo_path(@photo), notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        puts "failed to save\n"
        puts "Errors: #{@comment.errors.full_messages}\n"
        format.html { redirect_to photo_path(@photo), notice: 'Fill in missing fields' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to photo_url(@photo) }
      format.json { head :ok }
    end
  end
  
  private
  
  def init_variables
    @photo = Photo.find_by_id(params[:photo_id])
  end
end
