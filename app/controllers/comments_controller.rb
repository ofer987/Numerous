class CommentsController < ApplicationController
  before_action :init_variables
  
  # Negative captchas
  before_action :setup_negative_captcha, only: [:new, :create]
  
  skip_before_action :authorize

  # GET /comments
  # GET /comments.json
  def index
    @comments = @commentable.comments

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
    @comment = @commentable.comments.new

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
    @comment = @commentable.comments.build(@captcha.values)

    respond_to do |format|
      if @captcha.valid? && @comment.save
        format.html { redirect_to @commentable, notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { redirect_to photo_path(@commentable), notice: 'Fill in missing fields' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(@captcha.values)
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
      format.html { redirect_to root_path }
      format.json { head :ok }
    end
  end
  
  private
  
  def init_variables
    if params[:photo_id] != nil
      @commentable = Photo.find_by_id params[:photo_id]
    elsif params[:article_id] != nil
      @commentable = Article.find_by_id params[:article_id]
    else
      raise "Who does comment belong to?"
    end
  end
  
  def comment_params
    params.require(:comment).permit(:content, :user)
  end
  
  def setup_negative_captcha
    @captcha = NegativeCaptcha.new(
      secret: Numerous::Application.config.negative_captcha_secret,
      spinner: request.remote_ip,
      fields: [:content, :user],
      params: params
      )
  end
end
