class BlogPostsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index 
        render json: {status: 1, notice: 'List of all blog posts.', result: BlogPost.all}
    end

    def show 
        @blog_post = BlogPost.where(id: params[:blog_post_id])[0]
        if session[:user_id] != params[:user_id].to_i
            render json: {status: 0, notice: 'SignUp / Signin to read the blog...', result: {}}
        else 
            if session[:user_id] == @blog_post.user_id
                render json: {status: 1, notice: 'Blog.', result: @blog_post}
            else 
                @subscription = Subscription.where(user_id: session[:user_id])[0]
                if @subscription.allowedViews > 0
                    @subscription.allowedViews = @subscription.allowedViews-1
                    @subscription.save
                    render json: {status: 1, notice: 'Blog.', result: @blog_post}
                else 
                    render json: {status: 0, notice: 'Upgrade your subscription to view more...', result: {}}
                end
            end
        end
    end

    def showUserPost 
        @blog_post = BlogPost.where(user_id: params[:id])
        render json: {status: 1, notice: 'Successfully fecthed all user posts.', result: @blog_post}
    end

    def create 
        if session[:user_id] != params[:user_id].to_i
            render json: {status: 0, notice: 'SignUp / Signin to create the blog...', result: {}}
        else  
            @blog_post = BlogPost.new(blog_post_params)
            if @blog_post.save
                render json: {status: 1, notice: 'Successfully created the blog post.', result: @blog_post}
            else 
                render json: {status: 0, notice: 'Unable to create the blog post', result: {}}
            end
        end
    end

    def edit
        if session[:user_id] != params[:user_id].to_i
            render json: {status: 0, notice: 'SignUp / Signin to edit the blog...', result: {}}
        else  
            @blog_post = BlogPost.find(params[:id])
            if @blog_post.update(blog_post_params)
                render json: {status: 1, notice: 'Successfully edited the blog post.', result: @blog_post}
            else 
                render json: {status: 0, notice: 'Unable to edit the blog post', result: {}}
            end
        end
    end

    def destroy 
        if session[:user_id] != params[:user_id].to_i
            render json: {status: 0, notice: 'SignUp / Signin to delete the blog...', result: {}}
        else  
            @blog_post = BlogPost.find(params[:id])
            @blog_post.destroy
            render json: {status: 1, notice: 'Successfully deleted the blog post.', result: {}}
        end
    end

    def search 
        @authors      = User.where("firstname like ?", "%#{params[:searchParameter]}%") +
                        User.where("lastname like ?",  "%#{params[:searchParameter]}%") 
        @blog_post    = BlogPost.where("title like ?", "%#{params[:searchParameter]}%") + 
                        BlogPost.where("topic like ?", "%#{params[:searchParameter]}%") + 
                        BlogPost.where("body like ?",  "%#{params[:searchParameter]}%")
        
        for i in @authors do
            @blog_post = @blog_post + BlogPost.where(user_id: i.id)
        end
        render json: {status: 1, notice: 'Search Reults.', result: @blog_post.uniq}
    end

    def filter 
        @blog_post_all = BlogPost.all 
        @authors       = User.where("firstname like ?", "%#{params[:author]}%") +
                         User.where("lastname like ?",  "%#{params[:author]}%") 
        
        @blog_post     = []
        for i in @authors do
            @blog_post = @blog_post + BlogPost.where(user_id: i.id)
        end

        for i in @blog_post_all do
            helperLikes    = UserLikeBlogPost.where(blog_post_id: i.id).length
            helperComments = Comment.where(blog_post_id: i.id).length
            if  (helperLikes>=params[:minLikes].to_i) & (helperLikes<=params[:maxLikes].to_i); @blog_post = @blog_post + BlogPost.where(user_id: i.id); end
            if  (helperComments>=params[:minComments].to_i) & (helperComments<=params[:minComments].to_i); @blog_post = @blog_post + BlogPost.where(user_id: i.id); end
        end
        render json: {status: 1, notice: 'Filter Reults.', result: @blog_post.uniq}
    end

    def recomendation
        @topics = FollowsUsersTopic.where(user_id: params[:user_id]).to_a
        @blog_posts = []

        for @topic in @topics
            @helper = BlogPost.where("topic like ?", "%#{Topic.find(@topic.topic_id).topicname}%")
            @blog_posts = @blog_posts + @helper
        end
        
        render json: {status: 1, notice: 'Recomendation Reults.', result: @blog_posts.uniq}
    end

    def readingtime 
        @blog_post = BlogPost.find(params[:id])
        render json: {status: 1, notice: 'Reading time.', result: (((@blog_post.title + @blog_post.topic + @blog_post.body).split.size)/200.0).ceil()}
    end

    private 
    def blog_post_params
        params.permit(:title, :topic, :body, :imgurl, :views, :user_id)
    end
end