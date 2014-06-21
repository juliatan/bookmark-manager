post '/links' do
  url = params["url"]
  title = params["title"]

  tags = params["tags"].split(" ").map do |tag|
    #this will either find it or create it if it doesn't exist
    Tag.first_or_create(:text => tag)
  end
  # note that we are passing an array of instances to Link, rather than just text
  # because a tag is a database record of ID and text

  Link.create(:url => url, :title => title, :tags => tags)
  redirect to ('/')
end
# .create is a method from DataMapper that creates a new line in the database

get '/links/new' do
  erb :"links/new"
end