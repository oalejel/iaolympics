# Grade/class manager
# Ability to edit each class' theme, color, etc.

require 'sinatra'

require './models/grade'

module Olympics
	module Routes
		class Manager < Sinatra::Application
			get '/manager' do
				freshman_grade = Olympics::Models::FreshmanGrade.all[0]
				sophomore_grade = Olympics::Models::SophomoreGrade.all[0]
				junior_grade = Olympics::Models::JuniorGrade.all[0]
				senior_grade = Olympics::Models::SeniorGrade.all[0]
				erb :manager, :locals => {:freshman_grade => freshman_grade, :sophomore_grade => sophomore_grade,
										  :junior_grade => junior_grade, :senior_grade => senior_grade}
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