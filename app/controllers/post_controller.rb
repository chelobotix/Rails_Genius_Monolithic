class PostController < ApplicationController
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(post_params)
    @post.save
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
  end

  private
  def post_params
    params.require(:post).permit(:title_en, :title_es, :title_pt, :description_en, :description_es, :description_pt, :body_en, :body_es, :body_pt, :image_url, :thumbnail_url, :tags, :words, :year, :user_id)
  end
end
