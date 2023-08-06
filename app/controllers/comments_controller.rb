class CommentsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def show 
        render json: {status: 1, notice: 'Comment for this post.', result: Comment.where(blog_post_id: params[:blog_post_id])}
    end

    def create 
        if session[:user_id] != params[:user_id].to_i
            render json: {status: 0, notice: 'SignUp / Signin to edit the blog...', result: {}}
        else 
            @comment = Comment.new(comment_params)
            if @comment.save
                render json: {status: 1, notice: 'Comment was successfully created.', result: @comment}
            else
                render json: {status: 0, notice: 'Unable to create Comment.', result: {}}
            end
        end
    end

    def destroy 
        if session[:user_id] != params[:user_id].to_i
            render json: {status: 0, notice: 'SignUp / Signin to edit the blog...', result: {}}
        else 
            @comment = Comment.find(params[:id])
            @comment.destroy
            render json: {status: 1, notice: 'Comment was successfully deleted.', result: {}}
        end
    end

    private
    def comment_params
        params.permit(:user_id, :blog_post_id, :body)
    end
end