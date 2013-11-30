class BlogsController < ApplicationController
  skip_before_action :authorize, only: [:index, :show]

  def index
    @articles = Article.all.paginate(page: selected_page)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end
  
  private
  
  def selected_page
    params[:page]
  end
end
