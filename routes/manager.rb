# Grade/class manager
# Ability to edit each class' theme, color, etc.

require 'sinatra'
require 'json'

require './models/grade'

module Olympics
	module Routes
		class Manager < Sinatra::Application
			get '/manager' do
				erb :manager, :locals => {:grades => Olympics::Models::Grade.all}
				# Display the manager form
			end
			post '/manager' do
				# Updates classes using form data
				json_form_data = params[:data]
				form_data = JSON.parse(json_form_data)
				form_data.each do |form|
					year = form[:year]
					name = form[:name]
					colorhex = form[:color]
					theme = form[:theme]

					g = Grade.create(:year => year,
									:name => name,
									:colorhex => color,
									:theme => theme)
					
					"ok"
				end
			end
		end
	end
end