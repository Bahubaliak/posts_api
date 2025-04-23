# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  require 'httparty'

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    # Fetch all posts from jsonplaceholder
    posts = Rails.cache.fetch("json_placeholder_posts", expires_in: 10.minutes) do
      HTTParty.get("https://jsonplaceholder.typicode.com/posts").parsed_response
    end
    
    # Paginate posts manually using Kaminari
    paginated_posts = Kaminari.paginate_array(posts).page(page).per(per_page)

    # Return only the id and title fields
    posts_data = paginated_posts.map { |post| { id: post["id"], title: post["title"] } }

    render json: {
      posts: posts_data,
      total_pages: paginated_posts.total_pages,
      current_page: paginated_posts.current_page,
      per_page: per_page
    }
  rescue StandardError => e
    render json: { error: "Failed to fetch posts", message: e.message }, status: :bad_gateway
  end
end
