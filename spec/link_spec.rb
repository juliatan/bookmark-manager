require 'spec_helper'

describe Link do
  
  context 'Demonstration of how DataMapper works' do

    # This is not a real test, just a demo to see how DataMapper works
    it 'should be created and then retrieved from the db' do

      # In the beginning, our database is empty so there are no links
      expect(Link.count).to eq(0)

      # This creates it in the database, so it's stored on disk
      Link.create(:title => "Makers Academy",
                  :url => "http://www.makersacademy.com/")

      # We ask the database how many links there are, and it should be one
      expect(Link.count).to eq(1)

      # Let's get the first (and only) link from the database
      link = Link.first

      # Now it has all properties it was saved with
      expect(link.url).to eq("http://www.makersacademy.com/")
      expect(link.title).to eq("Makers Academy")

      # If we want to, we can delete it
      link.destroy

      #Now we have no links in the database
      expect(Link.count).to eq(0)

    end
  end
end