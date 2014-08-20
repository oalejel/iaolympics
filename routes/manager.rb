# Grade/class manager
# Ability to edit each class' theme, color, etc.

require 'sinatra'

module Olympics
	module Routes
		class Manager < Sinatra::Application
			get '/manager' do
				erb :manager
				# Display the manager form
			end
			post '/manager' do
				# Updates classes using form data
			end
		end
	end
end