class FrontpagesController < ApplicationController
  skip_before_action :authorize, only: :index

  def index
    @articles = Article.all.paginate(page: selected_page)
  end

  private

  def selected_page
    params[:page]
  end
end
