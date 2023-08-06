class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    render json: {status: 1, notice: 'User details.', result: User.where(id: params[:id])} 
  end

  def create
    @user = User.new(user_params)
    if @user.save
      Subscription.create(user_id: @user.id, tierfree: true, tier3d: false, tier5d: false, tier10d: false, allowedViews: 1,)
      session[:user_id] = @user.id
      render json: {status: 1, notice: 'User was successfully created...', result: @user}
    else
      render json: {status: 0, notice: 'Unable to create user', result: {}}
    end
  end

  def edit
    if session[:user_id] != params[:user_id].to_i
      render json: {status: 0, notice: 'SignUp / Signin to edit the user details...', result: {}}
    else 
      @user = User.find(params[:id])
      if @user.update(user_params)
        render json: {status: 1, notice: 'User was successfully edited...', result: @user}
      else 
        render json: {status: 0, notice: 'Unable to edit user', result: {}}
      end
    end
  end

  def signin
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      render json: {status: 1, notice: 'Signed in successfully', result: @user}
    else
      render json: {status: 0, notice: 'Invalid email/password combination.', result: {}}
    end
  end

  def signout
    session[:user_id] = nil
    render json: {status: 1, notice: 'Logged out successfully.', result: {}}
  end

  private
  def user_params
    params.permit(:email, :password, :password_confirmation, :firstname, :lastname, :bio, :profilepicture)
  end
end
