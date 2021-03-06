# require only the gems / files not needed in testing
require 'sinatra'
require 'data_mapper'
require 'sinatra/flash'
require 'sinatra/partial'
require 'rest_client' # this is for sending the email for password reset

require_relative 'helpers/application'
require_relative 'helpers/email'
require_relative 'data_mapper_setup'

require_relative 'controllers/users'
require_relative 'controllers/sessions'
require_relative 'controllers/links'
require_relative 'controllers/tags'
require_relative 'controllers/application'

enable :sessions
set :session_secret, 'super secret'
#Then, let's save the user ID in the session after it is created

# use Rack::Flash
register Sinatra::Flash
set :partial_template_engine, :erb

use Rack::Static, :urls => ['/css', '/js', '/images'], :root => 'public' # to get rackup to work