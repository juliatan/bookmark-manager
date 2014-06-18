get '/tags/:text' do
  tag = Tag.first(:text => params[:text])
  # setting @links to be equal to the result from the tag ? tag.links : [] operator
  @links = tag ? tag.links : []
  erb :index
end