require 'sinatra'

module Olympics
	module Routes
		class Login < Sinatra::Application
			configure do
				enable :sessions
			end
			get '/login' do
				if session[:authtoken] == nil
					redirect '/login'
				else
					erb :entry
				end
				# display form
			end
			post '/login' do
				# handle form data
				if params[:password] == 'supersecretphrase'
					session[:authtoken] = 'authtoken'
					redirect '/entry'
				else
					erb :login, :locals => {:error => "Incorrect password."}
				end
			end
		end
	end
end