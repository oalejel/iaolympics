require 'sinatra'

module Olympics
	module Routes
		class Entry < Sinatra::Application
			configure do
				enable :sessions
			end
			get '/entry' do
				if session[:authtoken] == nil
					redirect '/login'
				else
					erb :entry
				end
				# display form
			end
			post '/entry' do
				# handle form data
			end
		end
	end
end