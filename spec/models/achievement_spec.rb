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

	it 'converts markdown to html' do
		achievement = Achievement.new(description: 'Avesome **thing** I *actually* did')
		expect(achievement.description_html).to include('<strong>thing</strong>')
		expect(achievement.description_html).to include('<em>actually</em>')
	end

	it 'has silly title' do
		achievement = Achievement.new(title: "New achievement", user: FactoryGirl.create(:user, email: 'test@test.com'))
		expect(achievement.silly_title).to eq('New achievement by test@test.com')
	end

	it 'only fetches achievements which title starts from provided letters' do
		user = FactoryGirl.create(:user)
		achievement1 = FactoryGirl.create(:public_achievement, title: "Read a book", user: user)
		achievement2 = FactoryGirl.create(:public_achievement, title: "Passed an exam", user: user)
		expect(Achievement.by_letter("R")).to eq([achievement1])
		expect(Achievement.by_letter("P")).to eq([achievement2])
	end

	it 'sort achievements by user email' do
		user1 = FactoryGirl.create(:user, email: "marcin@wp.pl")
		user2 = FactoryGirl.create(:user, email: "zenek@wp.pl")
		achievement1 = FactoryGirl.create(:public_achievement,title: "Read a book", user: user1)
		achievement2 = FactoryGirl.create(:public_achievement,title: "Pocket it", user: user2)

		expect(Achievement.by_letter("R")).to eq([achievement1, achievement2])
	end
end