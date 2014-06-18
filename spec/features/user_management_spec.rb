require 'spec_helper'

feature 'User signs up', :focus => true do

# Strictly speaking, the tests that check the UI 
  # (have_content, etc.) should be separate from the tests 
  # that check what we have in the DB. The reason is that 
  # you should test one thing at a time, whereas
  # by mixing the two we're testing both 
  # the business logic and the views.
  #
  # However, let's not worry about this yet 
  # to keep the example simple.

  scenario 'when being logged out' do
    lambda { sign_up }.should change(User, :count).by 1
    expect(page).to have_content "Welcome, alice@example.com"
    expect(User.first.email).to eq "alice@example.com"
  end

  scenario "with a password that doesn't match" do
    lambda { sign_up('a@a.com', 'pass', 'wrong') }.should change(User, :count).by(0)
  end

  def sign_up(email = "alice@example.com",
              password="oranges!",
              password_confirmation="oranges!")
    visit '/users/new'
    expect(page.status_code).to eq(200)
    expect(page.status_code).to eq(200)
    fill_in :email, :with => email
    fill_in :password, :with => password
    fill_in :password_confirmation, :with => password_confirmation
    click_button "Sign up"
  end

end