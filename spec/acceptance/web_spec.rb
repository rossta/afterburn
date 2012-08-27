require 'acceptance/acceptance_helper'

feature 'Web server', :vcr do
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

    page.should have_content("Edit Project")

    fill_in "Name", with: "ActIn"
    click_button "Save"

    page.should have_content("ActIn")
  end

  scenario 'edit lists', :js, record: :all do
    visit burn_path

    click_link "Edit"

    within "tr[data-role='list']:first-child" do
      select "WIP", from: "Role"
    end

    click_link "Done"

    Afterburn.current_projects.first.lists.first.role.should eq("WIP")
  end

end