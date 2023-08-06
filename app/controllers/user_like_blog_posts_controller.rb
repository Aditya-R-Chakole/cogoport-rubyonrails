class UserLikeBlogPostsController < ApplicationController 
    skip_before_action :verify_authenticity_token

    def isLiked
        render json: {status: 1, notice: 'used liked this post or not.', result: UserLikeBlogPost.where(user_id: params[:user_id], blog_post_id: params[:blog_post_id]).length} 
    end

    def toggleLike 
        if session[:user_id] != params[:user_id].to_i
            render json: {status: 0, notice: 'SignUp / Signin to edit the blog...', result: {}}
        else 
            like = UserLikeBlogPost.where(user_id: params[:user_id], blog_post_id: params[:blog_post_id])
            if like.length == 0
                UserLikeBlogPost.create(user_id: params[:user_id], blog_post_id: params[:blog_post_id])
            else
                like[0].destroy
            end

            render json: {status: 1, notice: 'Like toggled...', result: UserLikeBlogPost.all}
        end
    end

    def getTotalLikes 
        render json: {status: 1, notice: 'Like toggled...', result: UserLikeBlogPost.where(blog_post_id: params[:blog_post_id])}
    end

end