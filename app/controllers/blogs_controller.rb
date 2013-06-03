class BlogsController < ApplicationController
  skip_before_filter :authorize, only: [:index, :show]

  def index
    @articles = Article.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end

  def show
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end
  end
end
