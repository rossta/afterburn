require 'acceptance/acceptance_helper'

feature 'Homepage', %q{
}, :vcr do
  before do
    authorize_account
  end

  scenario 'visit home page' do
    visit burn_path

    page.should have_content('Afterburn')
  end

  scenario 'show project' do
    visit burn_path

    within(".projects") do
      click_link "ActOut"
    end

    page.should have_content("ActOut")
  end

  scenario 'edit project' do
    visit burn_path

    click_link "Edit"

    page.should have_content("Edit the Project")

    fill_in "Name", with: "ActIn"
    click_button "Save"

    page.should have_content("ActIn")
  end

end