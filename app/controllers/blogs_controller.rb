class BlogsController < ApplicationController
  skip_before_action :authorize, only: [:index, :show]

  def index
    @articles = Article.order('created_at DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end
end
