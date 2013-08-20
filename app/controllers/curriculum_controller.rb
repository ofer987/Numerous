class CurriculumController < ApplicationController
  skip_before_action :authorize, only: [:index]

  def index
  end
end
