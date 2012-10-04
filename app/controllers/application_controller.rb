class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_home_url
  
  before_filter :authorize

  protected

    def set_home_url
      @home_url = "http://localhost:3000/assets/photos/";
    end
    
    def authorize
      unless User.find_by_id(session[:user_id])
        redirect_to login_url, notice: 'Please log in'
      end
    end
    
    def get_selected_tag_names
      @selected_tag_names = params[:tags]
      
      if (@selected_tag_names != nil and @selected_tag_names.strip != '')
        return @selected_tag_names.split(',').map { |name| name.strip.downcase }
      end
      
      return Array.new
    end
end
