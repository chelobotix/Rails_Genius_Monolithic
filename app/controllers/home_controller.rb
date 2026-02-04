class HomeController < ApplicationController
  def index
    @posts = Post.all

    render json: @posts
  end
end
