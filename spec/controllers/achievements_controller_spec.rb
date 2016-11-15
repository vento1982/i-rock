require 'rails_helper'

describe AchievementsController do
	describe 'GET new' do
		it 'renders :new template' do
			get :new
			expect(response).to render_template(:new)
		end
		it 'assigned new Achievement to @achievement' do
			get :new
			expect(assigns(:achievement)).to be_a_new(Achievement)
		end
	end

	describe 'GET show' do
		let(:achievement) {FactoryGirl.create(:achievement)}
		it 'renders :show template' do
			get :show, id:achievement.id
			expect(response).to render_template(:show)
		end
		it 'assigned requested achievement to @achievement' do
			get :show, id: achievement.id
			expect(assigns(:achievement)).to eq(achievement)
		end
	end
	describe 'POST create' do
		let(:valid_data) {FactoryGirl.attributes_for(:private_achievement)}
		context "valid data" do
			it "redirects to achievements#show" do 
				post :create, achievement: valid_data
				expect(response).to redirect_to(achievement_path(assigns[:achievement]))
			end
			it 'creates new achievement in database' do
				expect{
					post :create, achievement: valid_data
				}.to change(Achievement, :count).by(1)
			end
		end

		context "invalid data" do
			let(:invalid_data) {FactoryGirl.attributes_for(:private_achievement, title: '')}
			it "renders :new template" do
				post :create, achievement: invalid_data
				expect(response).to render_template(:new)
			end
			it "dosen't create new achievement in database" do
				expect{
					post :create, achievement: invalid_data
				}.not_to change(Achievement, :count)
			end 
		end
	end
end