class PostsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :is_admin?, only: [:edit, :destroy, :new]

  def index
   @posts = Post.all.order('created_at DESC')
  end 

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to @post
    else
      render 'new'
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
   @post = Post.find(params[:id])
   if @post.update(post_params)
     redirect_to @post
   else
     render 'edit'
   end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    redirect_to root_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end

  def is_admin?
    if !current_user.try(:admin?)
	flash[:danger] = "You are not allowed to create posts"
	redirect_to root_path
    end
  end
end
