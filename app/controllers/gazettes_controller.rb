class GazettesController < ApplicationController
  def index
    @gazettes = Gazette.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @gazettes }
    end
  end
  
  def show
    @gazette = Gazette.find_by_id(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gazette }
    end
  end
  
  def destroy
    @gazette = Gazette.find(params[:id])
    begin
      @gazette.destroy
      flash[:notice] = "Gazette (#{@gazette.name}) was deleted"
    rescue Exception => e
      flash[:notice] = e.message
    end
    
    respond_to do |format|
      format.html { redirect_to gazettes_url }
      format.json { head :ok }
    end
  end
  
  def new
    @gazette = Gazette.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @gazette }
    end
  end
  
  def edit
    @gazette = Gazette.find(params[:id])
  end
  
  def create
    @gazette = Gazette.new(params[:gazette])
    
    respond_to do |format|
      if @gazette.save
        format.html { redirect_to '/blogs/index' }
        format.json { render json: @gazette, status: :created, location: @gazette }
      else
        format.html { render action: "new" }
        format.json { render json: @gazette.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @gazette = Gazette.find(params[:id])  
    
    respond_to do |format|
      if @gazette.update_attributes(params[:gazette])
        format.html { redirect_to 'blogs/index' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @gazette.errors, status: :unprocessable_entity }
      end
    end
  end
end