class BilletsController < ApplicationController
  skip_before_action :authorize, only: [:index, :show]

  # Negative captcha
  before_action :setup_comment_negative_captcha, only: :show

  def index
    @billets = Billet.all.paginate(page: selected_page)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @billet = Billet.find_by_id(params[:id])
    @edit_mode = false

    # New comment
    # Note: we do not know for which billet this comment should be.
    @comment = Comment.new

    respond_to do |format|
      format.html # show.html.erb
      format.js
    end
  end

  def destroy
    @billet = Billet.find(params[:id])
    begin
      @billet.destroy
      flash[:notice] = "billet (#{@billet.title}) was deleted"
    rescue Exception => e
      flash[:notice] = e.message
    end

    redirect_to billets_url
  end

  def new
    @billet = Billet.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @billet = Billet.find(params[:id])
    @all_photos = Photo.all
    @edit_mode = true

    respond_to do |format|
      format.html # edit.html
    end
  end

  def create
    @billet = Billet.new(billet_params)
    @billet.tags_attributes = tags_params

    # Save the billet first and then the dependent associations
    if @billet.save
      redirect_to billet_path(@billet)
    else
      # Save failed
      redirect_to new_billet_path
    end
  end

  def create_photo
    @billet = Billet.find_by_id(params[:billet_id])
    @photo = @billet.photos.create(load_photo_file: photo_params[:load_photo_file])

    if @photo and @photo.valid?
      render file: 'billets/create_photo.js'
    else
      render file: 'billets/error.js', locals: { notice: "Error uploading file" }
    end
  end

  def update
    @billet = Billet.find(params[:id])

    @billet.attributes = billet_params
    if @billet.save
      render file: 'billets/show.js'
    else
      render file: 'billets/error.js', locals: { notice: "Error updating billet" }
    end
  end

  private

  def selected_page
    params[:page]
  end

  def photo_params
    params.require(:photo).permit(:load_photo_file)
  end

  def billet_params
    # maybe should be billet_photos_attributes instead of billet_photos
    params.require(:billet).permit(:title, :sub_title,
                                    :content, :published_at,
      billet_photos_attributes: [:is_selected, :id])
  end

  def tags_params
    params.require(:billet).permit(:tags_attributes)
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
