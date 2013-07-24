class BlogsController < ApplicationController
  skip_before_filter :authorize, only: [:index, :show]

  def index
    @articles = Article.order('created_at DESC')
    
    # New comment
    # Note: we do not know for which article this comment should be.
    @comment = Comment.new
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end
end
