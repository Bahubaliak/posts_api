require 'rails_helper'

RSpec.describe PostsController, type: :request do
  describe "GET /posts" do
    before do
      # Clear cache before each test to simulate fresh API fetch
      Rails.cache.delete("json_placeholder_posts")
    end

    it "returns a successful response" do
      get "/posts"
      expect(response).to have_http_status(:ok)
    end

    it "returns only id and title for paginated posts" do
      get "/posts", params: { page: 1, per_page: 5 }

      json = JSON.parse(response.body)

      expect(json["posts"]).to be_an(Array)
      expect(json["posts"].length).to eq(5)

      json["posts"].each do |post|
        expect(post.keys).to contain_exactly("id", "title")
      end
    end

    it "includes pagination metadata in the response" do
      get "/posts", params: { page: 2, per_page: 10 }

      json = JSON.parse(response.body)

      expect(json["current_page"]).to eq(2)
      expect(json["per_page"].to_i).to eq(10)
      expect(json).to have_key("total_pages")
    end

    it "returns an error if the external API fails" do
      allow(HTTParty).to receive(:get).and_raise(StandardError.new("Timeout"))
    
      get "/posts"
    
      json = JSON.parse(response.body)
      expect(response).to have_http_status(:bad_gateway)
      expect(json).to include("error" => "Failed to fetch posts")
      expect(json["message"]).to eq("Timeout")
    end    
  end
end
