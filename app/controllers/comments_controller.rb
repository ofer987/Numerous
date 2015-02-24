class CommentsController < ApplicationController
  before_action :init_variables

  # Negative captchas
  before_action :setup_negative_captcha, only: [:new, :create]

  skip_before_action :authorize, only: :create

  # POST /comments
  # POST /comments.json
  def create
    @comment = @commentable.comments.build(comment_params)

    respond_to do |format|
      if @comment_captcha.valid? && @comment.save
        format.html { redirect_to @commentable,
                      notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created,
                      location: @comment }
      else
        format.html { redirect_to @commentable,
                      notice: 'Fill in missing fields' }
        format.json { render json: @comment.errors,
                      status: :unprocessable_entity }
      end
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
    if ENV["RAILS_ENV"].downcase == 'test'
      params.require(:comment).permit(:content, :user)
    else
      @comment_captcha.values
    end
  end

  def setup_negative_captcha
    @comment_captcha = RefusalCaptcha.new(
      secret: Numerous::Application.config.negative_captcha_secret,
      spinner: request.remote_ip,
      fields: [:content, :user],
      params: params
      )
  end
end
