class PostsController < ApplicationController
  before_action :authorized
  before_action :user_permissions, only: [:update, :destroy]
  before_action :set_post, only: [:show, :update, :destroy]

  # GET /posts
  def index
    @posts = Post.all
    render :json => {
      :data => @posts.as_json(:except => [:user_id], :include => {:user => {:only => :name}, :tags => {:only => :name}})
    }
  end

  # GET /posts/1
  def show
    render :json => {
      :data => @post.as_json(:except => [:user_id], :include => {:user => {:only => :name}, :tags => {:only => :name}})
    }
  end

  # POST /posts
  def create
    @post = Post.new(post_params)
    @post.user_id = @current_user.id
    @post.tags << Tag.find(params[:tags])

    if @post.save
      render :json => {
      :data => @post.as_json(:except => [:user_id], :include => {:user => {:only => :name}, :tags => {:only => :name}})
    }, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update

    if @post.update(post_params)
      render :json => {
        :data => @post.as_json(:except => [:user_id], :include => {:user => {:only => :name}, :tags => {:only => :name}})
      }
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # User roles 
    def user_permissions
      @post = Post.find(params[:id])
      if @post.user_id != @current_user.id
        render json: { message: 'you do not have permission' }, status: :unauthorized 
      end
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :body, :user_id, :tags)
    end
end
