class EncouragementsController < ApplicationController
	before_action :authenticate_user
	before_action :authors_are_not_allowed
	before_action :authors_left
	
	def new
		@encouragement = Encouragement.new
	end

	def create
		@encouragement = @achievement.encouragements.create(encouragement_params)
		@encouragement.user_id = current_user.id
		if @encouragement.save
			redirect_to achievement_path(@achievement), notice: 'Thank You for encouragement'
		else
			render 'new'
		end
	end

	private
	
	def encouragement_params
		params.require(:encouragement).permit(:message)
	end

	def authenticate_user
		@achievement = Achievement.find(params[:achievement_id])

		unless current_user
			redirect_to achievement_path(@achievement), alert: 'You must be logged in to encourage people'
			return
		end
	end

	def authors_are_not_allowed
		if current_user.id == @achievement.user_id
			redirect_to achievement_path(@achievement), alert: "You can't encourage yourself"
		end
	end

	def authors_left
		if Encouragement.exists?(user: current_user, achievement: @achievement)
			redirect_to achievement_path(@achievement), alert: "YES"
			return
		end
	end
end