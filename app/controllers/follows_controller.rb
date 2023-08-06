class FollowsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def isFollowed 
        if session[:user_id] != params[:user_id].to_i
            render json: {status: 0, notice: 'SignUp / Signin to edit the blog...', result: {}}
        else 
            @user1 = User.find(params[:user1_id])
            @user2 = User.find(params[:user2_id])
            render json: {status: 1, notice: 'Follow result.', result: @user1.following?(@user2)}
        end
    end

    def toggleFollow
        if session[:user_id] != params[:user_id].to_i
            render json: {status: 0, notice: 'SignUp / Signin to edit the blog...', result: {}}
        else 
            @user1 = User.find(params[:user1_id])
            @user2 = User.find(params[:user2_id])
            if @user1.following?(@user2)
                @user1.unfollow(@user2)
            else 
                @user1.follow(@user2) 
            end

            render json: {status: 1, notice: 'Follow toggled.', result: @user1.following?(@user2)}
        end
    end

    def getAllFollows 
        if session[:user_id] != params[:user_id].to_i
            render json: {status: 0, notice: 'SignUp / Signin to edit the blog...', result: {}}
        else 
            @user1 = User.find(params[:id])
            render json: {status: 1, notice: 'All followerrs list.', result: @user1.followed_users}
        end
    end
end