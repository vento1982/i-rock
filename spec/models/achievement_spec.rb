require 'rails_helper'

RSpec.describe Achievement, type: :model do
	describe 'validates' do
		it 'requires title' do
			achievement = Achievement.new(title: '')
			achievement.valid?
			expect(achievement.valid?).to be_falsy
		end

		it 'requires title to be unique for one user' do 
			user = FactoryGirl.create(:user)
			first_achievement = FactoryGirl.create(:public_achievement, title: 'First Achievement', user: user)
			new_achievement = Achievement.create(title: 'First Achievement', user: user)
			expect(new_achievement.valid?).to be_falsy 
		end

		it 'allows different users to have achievements with identical title' do
			user = FactoryGirl.create(:user)
			user1 = FactoryGirl.create(:user)
			first_achievement = FactoryGirl.create(:public_achievement, title: 'First Achievement', user: user)
			new_achievement = Achievement.create(title: 'First Achievement', user: user1)
			expect(new_achievement.valid?).to be_truthy
		end

		it 'belongs to user' do
			achievement = Achievement.new(title: "Some title", user: nil)
			expect(achievement.valid?).to be_falsy
		end

		it 'has balongs_to user assotiation' do
			user = FactoryGirl.create(:user)
			achievement = FactoryGirl.create(:public_achievement, user: user)
			expect(achievement.user).to eq(user)

			u = Achievement.reflect_on_association(:user)
			expect(u.macro).to eq(:belongs_to)
		end
	end
end