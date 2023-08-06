Rails.application.routes.draw do
  post "/user/signup/", to: "users#create"
  post "/user/signin/", to: "users#signin"
  delete "/user/signout/", to: "users#signout"
  post "/user/edit/", to:"users#edit"
  get "/user/:id", to: "users#show"

  get "/like/is/", to: "user_like_blog_posts#isLiked"
  post "/like/toggle/", to: "user_like_blog_posts#toggleLike"
  get "/like/all/", to: "user_like_blog_posts#getTotalLikes"

  get "/comment/all/", to: "comments#show"
  post "/comment/create/", to: "comments#create"
  delete "/comment/destroy/", to: "comments#destroy"

  get "/follow/is/", to: "follows#isFollowed"
  post "/follow/toggle/", to: "follows#toggleFollow"
  get "/follow/all/:id", to: "follows#getAllFollows"

  get "/follow_topic/is/", to: "follows_users_topics#isFollowed"
  post "/follow_topic/toggle/", to: "follows_users_topics#toggleFollow"
  get "/follow_topic/all/:id", to: "follows_users_topics#getAllFollows"
  
  get "/checkout/", to: "subscriptions#checkOut"
  post "/subscriptions/", to: "subscriptions#subscriptions"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  post "/blog_posts/create/", to:"blog_posts#create"
  post "/blog_posts/edit/", to:"blog_posts#edit"
  delete "/blog_posts/destroy/:id", to: "blog_posts#destroy"

  get "/blog_posts/filter/", to: "blog_posts#filter"
  get "/blog_posts/search/", to: "blog_posts#search"
  get "/blog_posts/recomendation/", to: "blog_posts#recomendation"
  get "/blog_posts/readingtime/:id", to: "blog_posts#readingtime"
  get "/blog_posts/user/:id", to: "blog_posts#showUserPost"
  get "/blog_posts/", to: "blog_posts#show"

  # Defines the root path route ("/")
  # root "articles#index"
  root "blog_posts#index"
end
