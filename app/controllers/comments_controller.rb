class CommentsController < ApplicationController
  before_action :authorized
  before_action :set_current_post, only: [:create]
  before_action :user_permissions, only: [:update, :destroy]
  before_action :set_comment, only: [:show, :update, :destroy]

  # GET /comments
  def index
    @comments = Comment.all

    render :json => {
      :data => @comments.as_json(:except => [:user_id], :include => {:user => {:only => :name}})
    }
  end

  # GET /comments/1
  def show
    render :json => {
      :data => @comment.as_json(:except => [:user_id], :include => {:user => {:only => :name}})
    }
  end

  # POST /comments
  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = @current_user.id
    @comment.post_id = @current_post.id
    if @comment.save
      render :json => {
        :data => @comment.as_json(:except => [:user_id], :include => {:user => {:only => :name}})
      }, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      render :json => {
        :data => @comment.as_json(:except => [:user_id], :include => {:user => {:only => :name}})
      }
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
  end

  private

  def set_comment
      @comment = Comment.find(params[:id])
    end

    def set_current_post
      @current_post = Post.find(params[:post_id])
    end

    # User roles 
    def user_permissions
      @comment = Comment.find(params[:id])
      if @comment.user_id != @current_user.id
        render json: { message: 'you do not have permission' }, status: :unauthorized 
      end
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:body, :user_id, :post_id)
    end
end
