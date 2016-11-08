class AchievementsController < ApplicationController
  def new
  	@achievement = Achievement.new
  end

  def create
  	@achievement = Achievement.new(achievement_params)
  	if @achievement.save
  		redirect_to root_path, notice: "Achiviement has been created"
  	else
  		render 'new'
  	end
  end

  private

  def achievement_params
  	params.require(:achievement).permit(:title, :description, :privacy, :featured, :cover_image)
  end
end