require 'sinatra/base'
require 'rack'

require './routes/api'
require './routes/entry'
require './routes/manager'
require './routes/scoreboard'

module Olympics
	class App < Sinatra::Application
		configure do
			enable :sessions

			set :static, true
			set :public_dir, 'public'
			set :port, 1997
			set :views, File.dirname(__FILE__) + '/views'
		end

		use Olympics::Routes::API
		use Olympics::Routes::Entry
		use Olympics::Routes::Scoreboard
		use Olympics::Routes::Manager

	end
end

Rack::Server.start :app => Olympics::App