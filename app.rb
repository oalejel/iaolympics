require 'sinatra/base'
require 'rack'

require './routes/api'
require './routes/entry'
require './routes/login'
require './routes/manager'
require './routes/scoreboard'

load './models.rb'

Dir.glob('./models/*.rb').each do |file|
	load file
end

module Olympics
	class App < Sinatra::Application
		configure :development do
			DataMapper.setup(:default, "sqlite:///#{Dir.pwd}/olympics.db")
			DataMapper.finalize
			DataMapper.auto_upgrade!
		end

		configure :production do
			DataMapper.setup(:default, ENV['HEROKU_POSTGRESQL_RED_URL'])
			DataMapper.finalize
			DataMapper.auto_upgrade!
		end

		configure do
			enable :sessions

			set :static, true
			set :public_dir, 'public'
			set :views, File.dirname(__FILE__) + '/views'
		end

		use Olympics::Routes::API
		use Olympics::Routes::Entry
		use Olympics::Routes::Login
		use Olympics::Routes::Scoreboard
		use Olympics::Routes::Manager

	end
end

Olympics::App.run!