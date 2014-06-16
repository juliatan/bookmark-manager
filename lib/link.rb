# This class will correspond to the table in the database
# We can use it to manipulate database

class Link

  # The POST model needs to be persistent, therefore include Datamapper::Resource
  # This makes the instances of this class Datamapper resources
  # i.e. gives us custom methods to be used in this class Link
  include DataMapper::Resource

  # This block describes what resources our model will have
  property :id,     Serial # Serial means that it will be auto-incremented for every record
  property :title,  String
  property :url,    String

end