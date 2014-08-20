require 'sinatra'

module Olympics
	module Routes
		class Scoreboard < Sinatra::Application
			get '/' do
				# scoreboard
				erb :scoreboard
			end
		end
	end
end