require 'acceptance/acceptance_helper'

feature 'Web server', :vcr, :record => :new_episodes do
  before do
    authorize_account
  end

  scenario 'visit home page' do
    visit burn_path

    page.should have_content('Afterburn')
  end

  scenario 'show project' do
    visit burn_path

    within("ul.projects") do
      click_link "Challenges"
    end

    page.should have_content("Challenges")
  end

  scenario 'edit project' do
    visit burn_path
    click_link "Challenges"

    click_link "Edit"

    page.should have_content("Edit Project")

    fill_in "Name", with: "Platform"
    click_button "Save"

    page.should have_content("Platform")
  end

  scenario 'edit lists', :js, record: :all do
    visit burn_path

    click_link "Challenges"

    click_link "Edit"

    within "tr[data-role='list']:first-child" do
      select "WIP", from: "Role"
    end

    click_link "Done"

    Afterburn.all_projects.detect { |project| project.name =~ /Challenges/ }.lists.first.role.should eq("WIP")
  end

end
