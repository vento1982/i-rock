class AchievementsController < ApplicationController
  
  def show
    @achievement = Achievement.find(params[:id])
  end

  def new
  	@achievement = Achievement.new
  end

  def create
  	@achievement = Achievement.new(achievement_params)
  	if @achievement.save
  		redirect_to achievement_path(@achievement), notice: "Achiviement has been created"
  	else
  		render 'new'
  	end
  end

  private

  def achievement_params
  	params.require(:achievement).permit(:title, :description, :privacy, :featured, :cover_image)
  end
end
