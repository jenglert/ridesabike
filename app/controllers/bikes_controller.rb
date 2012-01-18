class BikesController < ApplicationController

  before_filter :login_required, :except => [:show]

  # GET /bikes/1
  # GET /bikes/1.xml
  def show
    @bike = Bike.find(params[:id])
    
    # Set the title
    @title = @bike.description

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bike }
    end
  end

  # GET /bikes/new
  # GET /bikes/new.xml
  def new
    @bike = Bike.new
    @bike.user_id = current_user.id
    
    @title = 'Create a New Bike'

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bike }
    end
  end

  # GET /bikes/1/edit
  def edit
    @bike = Bike.find(params[:id])
  end

  # POST /bikes
  # POST /bikes.xml
  def create
    @bike = Bike.new(params[:bike])
    
    # Set the title
    @title = @bike.description

    respond_to do |format|
      if @bike.save
        flash[:notice] = 'Bike was successfully created.'
        format.html { redirect_to(@bike) }
        format.xml  { render :xml => @bike, :status => :created, :location => @bike }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bike.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bikes/1
  # PUT /bikes/1.xml
  def update
    @bike = Bike.find(params[:id])
    
    # Set the title
    @title = @bike.description

    respond_to do |format|
      if @bike.update_attributes(params[:bike])
        flash[:notice] = 'Bike was successfully updated.'
        format.html { redirect_to(@bike) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bike.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bikes/1
  # DELETE /bikes/1.xml
  def destroy
    @bike = Bike.find(params[:id])
    @bike.destroy
    
    @title = 'Bike deleted'

    respond_to do |format|
      format.html { redirect_to(bikes_url) }
      format.xml  { head :ok }
    end
  end
end
