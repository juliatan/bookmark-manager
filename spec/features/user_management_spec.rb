require 'spec_helper'
require_relative 'helpers/sessions'

include SessionHelpers

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
    expect{ sign_up }.to change(User, :count).by 1
    # same as: expect(lambda { sign_up }).to change(User, :count).by 1
    expect(page).to have_content "Welcome, alice@example.com"
    expect(User.first.email).to eq "alice@example.com"
  end

  # the lambda about can be written as follows:
  # user_count = User.all.count
  # sign_up
  # expect(User.count).to eq (user_count+1)

  scenario "with a password that doesn't match" do
    expect{ sign_up('a@a.com', 'pass', 'wrong') }.to change(User, :count).by 0
    # expect(lambda { sign_up('a@a.com', 'pass', 'wrong') }).to change(User, :count).by 0
    expect(current_path).to eq '/users'
    expect(page).to have_content 'Sorry, your passwords do not match'
  end

  scenario "with an email that is already registered" do
    expect{ sign_up }.to change(User, :count).by 1
    expect{ sign_up }.to change(User, :count).by 0
    expect(page).to have_content "This email is already taken"
  end

end

feature "User signs in", :focus => true do

  before(:each) do
    User.create(:email => "test@test.com",
                :password => "test",
                :password_confirmation => "test")
  end

  scenario "with correct credentials" do
    visit '/'
    expect(page).not_to have_content "Welcome, test@test.com"
    sign_in("test@test.com", "test")
    expect(page).to have_content "Welcome, test@test.com"
  end

  scenario "with incorrect credentials" do
    visit '/'
    expect(page).not_to have_content "Welcome, test@test.com"
    sign_in("test@test.com", "wrong")
    expect(page).not_to have_content "Welcome, test@test.com"
  end

end

feature "User signs out", :focus => true do

  before(:each) do
    User.create(:email => "test@test.com",
                :password => "test",
                :password_confirmation => "test")
  end

  scenario 'while being signed in' do
    sign_in('test@test.com', "test")
    click_button 'Sign out'
    expect(page).to have_content "Goodbye!"
    expect(page).not_to have_content "Welcome, test@test.com"
  end

end

feature "User requests for password reset", :focus => true do

  before(:each) do
    @user1 = User.create(:email => "test@test.com",
                :password => "test",
                :password_confirmation => "test")
  end

  scenario 'when on the log in page' do
    visit('/sessions/new')
    click_link 'Forgot password'
    expect(page).to have_content "Enter your email"
  end

  scenario 'once user requests for password' do
    visit('/users/forgot_password')
    fill_in('email', :with => 'test@test.com')
    expect(User.first.password_token).to be nil
    expect(User.first.password_token_timestamp).to be nil
    click_button 'Submit'
    expect(page).to have_content "Go check your email"
    expect(User.first.password_token).not_to be nil
    expect(User.first.password_token_timestamp).not_to be nil
  end

  scenario 'once user clicks on email' do
    visit('/users/forgot_password')
    fill_in('email', :with => 'test@test.com')
    click_button 'Submit'
    token = User.first.password_token
    # debugger
    visit("/users/reset_password?token=#{token}")
    # save_and_open_page
    expect(page).to have_content "Enter your new password"
    fill_in('password', :with => 'test')
    fill_in('password_confirmation', :with => 'test')
    click_button 'Reset'
    token = User.first.password_token
    expect(token).to be nil
  end

end