Given(/^I am a guest user$/) do
end

Given(/^there is a public achievement$/) do
	@achievement=FactoryGirl.create(:achievement, title: 'I did it')
end 

When(/^I go to achievement's page$/) do
	visit(achievement_path(@achievement.id))
end

Then(/^I must see achievement's$/) do
  expect(page).to have_content('I did it')
end
