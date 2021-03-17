class PostsController < ApplicationController
  before_action :authenticate_user!,except: [:index,:show]
  def index 
   @tag_list = Tag.all
   @posts = Post.includes(:user)
   @post = current_user.posts.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    tag_list = params[:post][:tag_name].split(nil)
    if @post.save
      @post.save_tag(tag_list)
      redirect_to root_path
    else
      render :new
    end
  end
  
  def show
    @post = Post.find(params[:id])
    @post_tags = @post.tags
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post.id)
    else
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to root_path
  end

  def search
     @tag_list = Tag.all
     @tag = Tag.find(params[:tag_id])
     @posts = @tag.posts.all
  end

  private

  def post_params
    params.require(:post).permit(:text, :tops_shop, :tops_prefecture, :tops_brand, :tops_price, :pants_shop, :pants_prefecture_id, :pants_brand, :pants_price, :shoes_shop, :shoes_prefecture_id, :shoes_brand, :shoes_price, :image).merge(user_id: current_user.id)
  end

end
