require 'sinatra'

module Olympics
	module Routes
		class Login < Sinatra::Application
			configure do
				enable :sessions
			end
			get '/login' do
				erb :login
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
			get '/logout' do
				session[:authtoken] = nil
				redirect '/'
			end
		end
	end
end