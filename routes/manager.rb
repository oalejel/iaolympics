# Grade/class manager
# Ability to edit each class' theme, color, etc.

require 'sinatra'

require './models/grade'

module Olympics
	module Routes
		class Manager < Sinatra::Application
			get '/manager' do
				freshman_grade = Olympics::Models::Grade.first(:freshman => true)
				sophomore_grade = Olympics::Models::Grade.first(:sophomore => true)
				junior_grade = Olympics::Models::Grade.first(:junior => true)
				senior_grade = Olympics::Models::Grade.first(:senior => true)
				erb :manager, :locals => {:freshman_grade => freshman_grade, :sophomore_grade => sophomore_grade,
										  :junior_grade => junior_grade, :senior_grade => senior_grade}
				# Display the manager form
			end
			post '/manager' do
				# Updates classes using form data
				forms = params[:data]
				
				# Update freshmen

				freshman_data = form[1]

				freshman_grade = Olympics::Models::Grade.first(:freshman => true)
				if freshman_grade == nil
					freshman_grade = Olympics::Models::Grade.create(:year => freshman_data[:year], :name => freshman_data[:name], :colorhex => freshman_data[:colorhex], :theme => freshman_data[:theme],
																	:freshman => true, :sophomore => false, :junior => false, :senior => false)
				else
					freshman_grade.year = freshman_data[:year]
					freshman_grade.name = freshman_data[:name]
					freshman_grade.colorhex = freshman_data[:colorhex]
					freshman_grade.theme = freshman_data[:theme]
				end

				"ok"
			end
		end
	end
end