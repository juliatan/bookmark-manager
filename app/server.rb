# require only the gems / files not needed in testing
require 'sinatra'
require 'data_mapper'
require 'sinatra/flash'
require 'sinatra/partial'

require_relative 'models/link' # this needs to be done after DataMapper is initialised
require_relative 'models/tag'
require_relative 'models/user'

require_relative 'helpers/application'
require_relative 'data_mapper_setup'

require_relative 'controllers/users'
require_relative 'controllers/sessions'
require_relative 'controllers/links'
require_relative 'controllers/tags'
require_relative 'controllers/application'
require 'debugger'

enable :sessions
set :session_secret, 'super secret'
#Then, let's save the user ID in the session after it is created

# use Rack::Flash
register Sinatra::Flash
set :partial_template_engine, :erb