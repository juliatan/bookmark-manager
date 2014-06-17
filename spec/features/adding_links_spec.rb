require 'spec_helper'

feature 'User adds a new link', :focus => true do
  
  scenario "when browsing the homepage" do
    expect(Link.count).to eq(0)
    visit '/'
    add_link("http://www.makersacademy.com/", "Makers Academy")
    expect(Link.count).to eq(1)
    link = Link.first
    expect(link.url).to eq("http://www.makersacademy.com/")
    expect(link.title).to eq("Makers Academy")
  end

  scenario "with a few tags" do
    visit "/"
    add_link("http://www.makersacademy.com/",
              "Makers Academy",
              ['education', 'ruby'])
    link=Link.first
    # expect(link.tags).to include("education")
    # expect(link.tags).to include("ruby")
    # instead of expecting tags to be strings, we need to iterate through the
    # array of instances of the tag object
    expect(link.tags.map(&:text)).to include("education")
    expect(link.tags.map(&:text)).to include("ruby")
  end

  def add_link(url, title, tags=[])
    within('#new-link') do
      fill_in 'url', :with => url # mimicking form filling
      fill_in 'title', :with => title
      # our tags will be space separated
      fill_in 'tags', :with => tags.join(" ")
      click_button 'Add link'
    end
  end
end