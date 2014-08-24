# Grade/class manager
# Ability to edit each class' theme, color, etc.

require 'sinatra'

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
				forms = params[:data]
				forms.each do |form|
					grade = form[1]
					year = grade[:year]
					name = grade[:name]
					colorhex = grade[:color]
					theme = grade[:theme]

					g = Olympics::Models::Grade.create(:year => year,
									:name => name,
									:colorhex => colorhex,
									:theme => theme)
					
					"ok"
				end
			end
		end
	end
end