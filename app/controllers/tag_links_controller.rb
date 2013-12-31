class TagLinksController < ApplicationController
  before_action :set_tag_link, only: [:show, :edit, :update, :destroy]

  # GET /tag_links
  def index
    @tag_links = TagLink.all
  end

  # GET /tag_links/1
  def show
  end

  # GET /tag_links/new
  def new
    @tag_link = TagLink.new
  end

  # GET /tag_links/1/edit
  def edit
  end

  # POST /tag_links
  def create
    @tag_link = TagLink.new(tag_link_params)

    if @tag_link.save
      redirect_to @tag_link, notice: 'Tag link was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /tag_links/1
  def update
    if @tag_link.update(tag_link_params)
      redirect_to @tag_link, notice: 'Tag link was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /tag_links/1
  def destroy
    @tag_link.destroy
    redirect_to tag_links_url, notice: 'Tag link was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag_link
      @tag_link = TagLink.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def tag_link_params
      params.require(:tag_link).permit(:tag_id, :tagable_id, :tagable_type)
    end
end
