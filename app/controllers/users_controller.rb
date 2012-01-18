class UsersController < ApplicationController
 
  before_filter :login_required, :except => [ :index, :show ]
  before_filter :in_users_section

  def index
    @users = User.find(:all);
  end

  # GET /people/1/edit
  def edit
    @user = User.find(params[:id])
  end
  
  def show
    @user = User.find(params[:id])
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Your settings have been saved.'
        format.html { redirect_to(:controller=> 'biker_view') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
end
