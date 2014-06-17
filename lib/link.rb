# This class will correspond to the table in the database
# We can use it to manipulate database

class Link

  # The POST model needs to be persistent, therefore include Datamapper::Resource
  # This makes the methods of the Resource class in Datamapper available to
  # this Link class
  include DataMapper::Resource

  has n, :tags, :through => Resource #Tags model has a many to many relationship

  # This block describes what resources our model will have
  property :id,     Serial # Serial means that it will be auto-incremented for every record
  property :title,  String
  property :url,    String

  # each line created in this database represents an instance variable when a 
  # DataMapper is run over it

end

