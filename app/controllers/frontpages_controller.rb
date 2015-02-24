class FrontpagesController < ApplicationController
  def index
    @articles = Article.all.paginate(page: selected_page)
  end

  private

  def selected_page
    params[:page]
  end
end
