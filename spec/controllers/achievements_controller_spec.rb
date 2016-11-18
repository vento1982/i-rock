require 'rails_helper'

describe AchievementsController do
	
	shared_examples "public access to achievements" do
		describe "GET index" do
			
			it "renders :index template" do
				get :index
				expect(response).to render_template(:index)	
			end
			
			it "assigns only public achivements to template" do
				public_achievement = FactoryGirl.create(:public_achievement)
				private_achievement = FactoryGirl.create(:private_achievement)
				get :index
				expect(assigns(:achivements)).to match_array([public_achievement])
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
	end

	describe "guest user" do
		
		it_behaves_like "public access to achievements"

		describe 'GET new' do
			it "redirect to login page" do
				get :new
				expect(response).to redirect_to(new_user_session_path)
			end
		end

		describe 'POST create' do
			it "redirect to login page" do
				post :create, achievement: FactoryGirl.attributes_for(:public_achievement)
				expect(response).to redirect_to(new_user_session_path) 
			end
		end

		describe 'GET edit' do
			it 'redirect to login page' do
				get :edit,id: FactoryGirl.create(:public_achievement)
				expect(response).to redirect_to(new_user_session_path)
			end
		end

		describe 'PUT update' do
			it "redirect to login page" do
				put :update, id: FactoryGirl.create(:public_achievement), achievement: FactoryGirl.attributes_for(:public_achievement)
				expect(response).to redirect_to(new_user_session_path)
			end
		end

		describe "DELETE destroy" do
			it "redirect to login page" do
				delete :destroy, id: FactoryGirl.create(:public_achievement)
				expect(response).to redirect_to(new_user_session_path)
			end
		end
	end

	describe "authenticated user" do
		let(:user){FactoryGirl.create(:user)}
		before do
			sign_in(user)
		end

		it_behaves_like "public access to achievements"

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

		context "is not the owner of the achievement" do
			describe 'GET edit' do
				it 'redirect to achievements page' do
					get :edit,id: FactoryGirl.create(:public_achievement)
					expect(response).to redirect_to(achievements_path)
				end
			end

			describe 'PUT update' do
				it "redirect to achievements page" do
					put :update, id: FactoryGirl.create(:public_achievement), achievement: FactoryGirl.attributes_for(:public_achievement)
					expect(response).to redirect_to(achievements_path)
				end
			end

			describe "DELETE destroy" do
				it "redirect to achievements page" do
					delete :destroy, id: FactoryGirl.create(:public_achievement)
					expect(response).to redirect_to(achievements_path)
				end
			end
		end
		
		context "is the owner of the achievement" do
			let(:achievement){FactoryGirl.create(:achievement, user: user)}

			describe 'GET edit' do
				
				it 'renders :edit template' do
					get :edit, id: achievement
					expect(response).to render_template(:edit)
				end
				it 'assigned edit achievement to @achievement' do
					get :edit, id: achievement
					expect(assigns(:achievement)).to eq(achievement)
				end
			end

			describe 'PUT update' do 
				
				context "valid data" do
					let(:valid_data){FactoryGirl.attributes_for(:public_achievement, title: "New title")}
					it 'redirect_to achievements#show' do
						put :update, id: achievement, achievement: valid_data
						expect(response).to redirect_to(achievement)
					end	
					it 'updates achievement in database' do
						put :update, id: achievement, achievement: valid_data
						achievement.reload
						expect(achievement.title).to eq("New title")
					end
				end
			
				context "invalid data" do
					let(:invalid_data){FactoryGirl.attributes_for(:public_achievement, title: " ", description: "new")}
					it "render :edit template" do
						put :update, id: achievement, achievement: invalid_data
						expect(response).to render_template(:edit)
					end
					it "dosen't updates database" do
						put :update, id: achievement, achievement: invalid_data
						achievement.reload
						expect(achievement.description).not_to eq("new")
					end			
				end
			end

			describe "DELETE destroy" do
				it "redirects to achievements#index" do
					delete :destroy, id: achievement
					expect(response).to redirect_to(achievements_path)
				end
				it "deletes achievement from database" do
					delete :destroy, id: achievement
					expect(Achievement.exists?(achievement.id)).to be_falsey
				end
			end
		end
	end
end