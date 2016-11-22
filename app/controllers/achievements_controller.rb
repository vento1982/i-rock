class AchievementsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :owners_only, only: [:edit, :update, :destroy]

  def index
    @achivements = Achievement.public_access
  end

  def show
    @achievement = Achievement.find(params[:id])
  end

  def edit
  end
  
  def update
    if @achievement.update_attributes(achievement_params)
      redirect_to achievement_path(@achievement)
    else
      render 'edit'
    end
  end

  def destroy
    if @achievement.destroy
      redirect_to achievements_path
    end
  end

  def new
  	@achievement = Achievement.new
  end

  def create
  	@achievement = Achievement.new(achievement_params)
    @achievement.user = current_user
  	if @achievement.save
      UserMailer.achievement_created(current_user.email, @achievement.id).deliver_now
  		redirect_to achievement_path(@achievement), notice: "Achiviement has been created"
  	else
  		render 'new'
  	end
  end

  private

  def achievement_params
  	params.require(:achievement).permit(:title, :description, :privacy, :featured, :cover_image)
  end

  def owners_only
    @achievement = Achievement.find(params[:id])
    if current_user != @achievement.user
      redirect_to achievements_path
    end
  end
end
