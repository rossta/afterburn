require 'acceptance/acceptance_helper'

feature 'Homepage', %q{
} do

  scenario 'visit home page' do
    visit burn_path

    page.should have_content('Afterburn')
  end

end