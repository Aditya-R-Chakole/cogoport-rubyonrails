class FollowsUsersTopicsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def isFollowed 
        if session[:user_id] != params[:user_id].to_i
            render json: {status: 0, notice: 'SignUp / Signin to edit the blog...', result: {}}
        else
            @user  = User.find(params[:user_id])
            @topic = Topic.find(params[:topic_id])
            render json: {status: 1, notice: 'Used follow topic.', result: @user.following_topic?(@topic)}
        end
    end

    def toggleFollow 
        if session[:user_id] != params[:user_id].to_i
            render json: {status: 0, notice: 'SignUp / Signin to edit the blog...', result: {}}
        else
            @user  = User.find(params[:user_id])
            @topic = Topic.find(params[:topic_id])
            if @user.following_topic?(@topic)
                @user.unfollow_topic(@topic)
            else 
                @user.follow_topic(@topic) 
            end
            render json: {status: 1, notice: 'follow topic toggled.', result: @user.following_topic?(@topic)}
        end
    end

    def getAllFollows 
        if session[:user_id] != params[:user_id].to_i
            render json: {status: 0, notice: 'SignUp / Signin to edit the blog...', result: {}}
        else
            @user = User.find(params[:id])
            render json: {status: 1, notice: 'all follwed topics.', result: @user.followed_topics}
        end
    end
end