class UserController < ApplicationController

  #crear un usuario
  def create
    @user = User.create name: params[:name]
    @user.save!
    render json: {user: @user}
  end

end