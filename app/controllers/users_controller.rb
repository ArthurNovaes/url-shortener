class UsersController < ApplicationController
  before_action :set_user, only: [:destroy, :stats]

  def create
    if User.where(login: user_params[:login]).present?
      return render json: {message: 'Validation failed: This user already exists'}, status: :conflict
    end

    @user = User.create!(user_params)
    json_response(@user, :created)
  end

  def destroy
    @user.destroy
    head :no_content
  end

  def stats
    json_response(stats_response(@user.id))
  end

  private

  def user_params
    params.permit(:login)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
