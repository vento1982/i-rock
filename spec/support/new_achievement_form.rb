class NewAchievementForm
	include Capybara::DSL

	def visit_page
		visit('/')
 		click_on('New Achievement')
 		self
	end

	def fill_in_with(params = {})
		fill_in('Title', with: params.fetch(:title, 'Read a book'))
 		fill_in('Description', with: 'That was amazing book.')
 		select('Public', from: 'Privacy')
 		check('Feature achievement')
 		attach_file('Cover image', "#{Rails.root}/spec/fixtures/cover_image.png")
 		
 		self
	end

	def submit
		click_on('Create Achievement')
		self
	end
end