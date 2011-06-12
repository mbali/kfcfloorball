class UsersController < ApplicationController

  def index
    @users=User.find(:all,:order => :id)
  end

  def show
    @user=User.find(params[:id])
  end

  def edit
    @user=User.find(params[:id])
  end

  def update
    @user=User.find(params[:id])
    @user.update_attributes(params[:user])
    @user.save
    if @user.errors.empty?
      redirect_to(user_path(@user))
    else
      render :action => :edit
    end
  end

#  def new
#    @user = User.new(params[:user])
#  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to user_path(@user)
    else
      render :action => :new
    end
  end

  def destroy
    @user=User.find(params[:id])
    @user.destroy
    redirect_to :action => :index
  end
end
