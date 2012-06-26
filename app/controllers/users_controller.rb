class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pfitmap_releases }
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def toggle_role
    @user = User.find(params[:id])
    
    respond_to do |format|
      if @user.toggle_role
        format.html { re :template => "users/show" }
        format.json { render json: @users , status: :success }
      else
        format.html { redirect_to users_path(@user) }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @db_user = User.find(params[:id])
  end

  def update
    @db_user = User.find(params[:id])
    if current_user.role == 'admin'
      new_role = params[:user][:role]
      if User::ROLES.include? new_role
        @user.role = new_role
      end
      @user.update_attributes(params[:user])
      respond_to do |format|
        if @user.update_attributes(params[:user])
          format.html { redirect_to @user, notice: 'User was updated' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html {redirect_to root_path, notice: "You are not admin"}
        format.json { render json: @user.errors }
      end
    end
  end
end
