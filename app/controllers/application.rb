get '/' do
  @links = Link.all
  erb :index
end
# .all is a method from DataMapper that takes all lines in database and creates instance variables
# @links will be an array