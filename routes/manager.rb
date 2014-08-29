# Grade/class manager
# Ability to edit each class' theme, color, etc.

require 'sinatra'

require './models/grade'

module Olympics
	module Routes
		class PlaceholderGrade
			def initialize
				@year = "Year..."
				@colorhex = "#FFFFFF"
				@theme = "Theme..."
			end
			attr_reader  :year, :colorhex, :theme
		end
		class Manager < Sinatra::Application
			get '/manager' do
				freshman_grade = Olympics::Models::Grade.first(:freshman => true)
				sophomore_grade = Olympics::Models::Grade.first(:sophomore => true)
				junior_grade = Olympics::Models::Grade.first(:junior => true)
				senior_grade = Olympics::Models::Grade.first(:senior => true)

				# If the grades don't exist (first time loading up the form), fill it in with default values

				if freshman_grade == nil
					freshman_grade = PlaceholderGrade.new
				end
				if sophomore_grade == nil
					sophomore_grade = PlaceholderGrade.new
				end
				if junior_grade == nil
					junior_grade = PlaceholderGrade.new
				end
				if senior_grade == nil
					senior_grade = PlaceholderGrade.new
				end
				erb :manager, :locals => {:freshman_grade => freshman_grade, :sophomore_grade => sophomore_grade,
										  :junior_grade => junior_grade, :senior_grade => senior_grade}
				# Display the manager form
			end
			post '/manager' do
				# Updates classes using form data
				forms = params[:data]
				
				puts forms

				# Update freshmen

				freshman_data = forms["0"]
				freshman_grade = Olympics::Models::Grade.first(:freshman => true)
				if freshman_grade == nil
					freshman_grade = Olympics::Models::Grade.create(:year => freshman_data[:year], :colorhex => freshman_data[:color], :theme => freshman_data[:theme],
																	:freshman => true, :sophomore => false, :junior => false, :senior => false)
				else
					freshman_grade.year = freshman_data[:year]
					freshman_grade.colorhex = freshman_data[:color]
					freshman_grade.theme = freshman_data[:theme]
				end

				sophomore_data = forms["1"]
				sophomore_grade = Olympics::Models::Grade.first(:sophomore => true)
				if sophomore_grade == nil
					sophomore_grade = Olympics::Models::Grade.create(:year => sophomore_data[:year], :colorhex => sophomore_data[:color], :theme => sophomore_data[:theme],
																	:freshman => false, :sophomore => true, :junior => false, :senior => false)
				else
					sophomore_grade.year = sophomore_data[:year]
					sophomore_grade.colorhex = sophomore_data[:color]
					sophomore_grade.theme = sophomore_data[:theme]
				end

				junior_data = forms["2"]
				junior_grade = Olympics::Models::Grade.first(:junior => true)
				if junior_grade == nil
					junior_grade = Olympics::Models::Grade.create(:year => junior_data[:year], :colorhex => junior_data[:color], :theme => junior_data[:theme],
																:freshman => false, :sophomore => false, :junior => true, :senior => false)
				else
					junior_grade.year = junior_data[:year]
					junior_grade.colorhex = junior_data[:color]
					junior_grade.theme = junior_data[:theme]
				end

				senior_data = forms["3"]
				senior_grade = Olympics::Models::Grade.first(:senior => true)
				if senior_grade == nil
					senior_grade = Olympics::Models::Grade.create(:year => senior_data[:year], :colorhex => senior_data[:color], :theme => senior_data[:theme],
																 :freshman => false, :sophomore => false, :junior => false, :senior => true)
				else
					senior_grade.year = senior_data[:year]
					senior_grade.colorhex = senior_data[:color]
					senior_grade.theme = senior_data[:theme]
				end

				"ok"
			end
		end
	end
end