require 'sinatra'

module Olympics
	module Routes
		class Entry < Sinatra::Application
			get '/entry' do
				erb :entry
				# display form
			end
			post '/entry' do
				# handle form data
			end
		end
	end
end