class UsersController < ApplicationController
    
    # Register
    def register
      @user = User.create(user_params)
      if @user.valid?
        render :json => {
          :data => @user.as_json(:except => [:password_digest])
        }, status: :created
      else
        render json: {error: "Invalid email or password"}, status: :bad_request
      end
    end
  
    # Login 
    def login
      @user = User.find_by(email: params[:email])
  
      if @user && @user.authenticate(params[:password])
        token = encode_token({user_id: @user.id})
        render json: {token: token}
      else
        render json: {error: "Invalid email or password"}, status: :bad_request
      end
    end
  
    private
  
    def user_params
      params.permit(:name, :email, :password, :image)
    end
end
