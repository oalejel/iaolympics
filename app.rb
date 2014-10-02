require 'sinatra/base'
require 'rack'

require 'dm-core'
require 'dm-migrations'
require 'dm-serializer'

module Olympics
	module Models
		class Competition
			# Represents an olympics competition (the annual holding of olympics)
			# So there would be a separate instance for the 2014 olympics, 2015 olympics, etc.

			include DataMapper::Resource

			property :id, Serial
			property :year, Integer

			# has n, :events
		end
	end
end

module Olympics
	module Models
		class Event
			include DataMapper::Resource

			property :id, Serial
			property :name, String
			property :prettyname, String

			has 1, :firstplace
			has 1, :secondplace
			has 1, :thirdplace
			has 1, :fourthplace

		end

		class Firstplace
			include DataMapper::Resource

			# Represents a first place win
			belongs_to :grade, :key => true
			belongs_to :event, :key => true

			property :time, DateTime
		end

		class Secondplace
			include DataMapper::Resource

			# Represents a second place performance
			belongs_to :grade, :key => true
			belongs_to :event, :key => true

			property :time, DateTime
		end


		class Thirdplace
			include DataMapper::Resource

			belongs_to :grade, :key	=> true
			belongs_to :event, :key => true

			property :time, DateTime
		end

		class Fourthplace
			include DataMapper::Resource

			belongs_to :grade, :key => true
			belongs_to :event, :key => true

			property :time, DateTime
		end

	end
end

module Olympics
	module Models
		class Grade
			include DataMapper::Resource

			# Represents a class of IA students, e.g. the class of 2015
			# To avoid confusion with the word "class", the word "grade" is used
			
			property :id, Serial

			property :year, Integer
			property :colorhex, String # e.g. black would be 000000
			property :theme, String

			property :deducted_points, Integer

			# One of these must be true

			property :freshman, Boolean
			property :sophomore, Boolean
			property :junior, Boolean
			property :senior, Boolean

		end
	end
end

module Olympics
	class PlaceholderGrade
		def initialize
			@year = "Year..."
			@colorhex = "#FFFFFF"
			@theme = "Theme..."
		end
		attr_reader  :year, :colorhex, :theme
	end
	class App < Sinatra::Application
		configure do
			enable :sessions
		end

		configure :development do
			DataMapper.setup(:default, "sqlite:///#{Dir.pwd}/olympics.db")
			DataMapper.finalize
			DataMapper.auto_upgrade!
		end

		configure :production do
			DataMapper.setup(:default, ENV['DATABASE_URL'])
			DataMapper.finalize
			DataMapper.auto_upgrade!
		end

		configure do
			enable :sessions

			set :static, true
			set :public_dir, 'public'
			set :views, File.dirname(__FILE__) + '/views'
		end

		get '/api/generate' do
			# Generates a list of events (if they don't exist already)
			if Olympics::Models::Event.first(:name => "hallway") == nil
				# Since all of the events are created in batch, if one event doesn't exist then none exist.
				Olympics::Models::Event.create(:name => "hallway", :prettyname => "Hallway")
				Olympics::Models::Event.create(:name => "tshirt", :prettyname => "T-shirt")
				Olympics::Models::Event.create(:name => "class-banner", :prettyname => "Class Banner")
				Olympics::Models::Event.create(:name => "tug-of-war", :prettyname => "Tug of War")
				Olympics::Models::Event.create(:name => "oakland-county-500-race", :prettyname => "Oakland County 500 - Race")
				Olympics::Models::Event.create(:name => "oakland-county-500-artistic", :prettyname => "Oakland County 500 - Artistic")
				Olympics::Models::Event.create(:name => "watermelon-eating-contest", :prettyname => "Watermelon Eating Contest")
				Olympics::Models::Event.create(:name => "egg-toss", :prettyname => "Egg Toss")
				Olympics::Models::Event.create(:name => "four-legged-race", :prettyname => "Four Legged Race")
				Olympics::Models::Event.create(:name => "ac-surprise", :prettyname => "Adventure Challenge Surprise")
				Olympics::Models::Event.create(:name => "euchre", :prettyname => "Euchre Tournament")
				Olympics::Models::Event.create(:name => "chess", :prettyname => "Team Chess")
				Olympics::Models::Event.create(:name => "trivial-pursuit", :prettyname => "Trivial Pursuit")
				Olympics::Models::Event.create(:name => "team-ninja", :prettyname => "Ninja")
				Olympics::Models::Event.create(:name => "gladiator", :prettyname => "Gladiator")
				Olympics::Models::Event.create(:name => "millionaire", :prettyname => "Who Wants to be a Millionaire?")
				Olympics::Models::Event.create(:name => "ultimate-frisbee", :prettyname => "Ultimate Frisbee")
				Olympics::Models::Event.create(:name => "volleyball", :prettyname => "5 on 5 Volleyball")
				Olympics::Models::Event.create(:name => "mural-contest", :prettyname => "Blacktop Mural Contest")
				Olympics::Models::Event.create(:name => "basketball", :prettyname => "3 on 3 Basketball")
				Olympics::Models::Event.create(:name => "4-square", :prettyname => "4 Square")
				Olympics::Models::Event.create(:name => "soccer", :prettyname => "Soccer")
				"ok"
			elsif Olympics::Models::Event.first(:name => "spirit-week") == nil
				Olympics::Models::Event.create(:name => "penny-wars", :prettyname => "Penny Wars")
				Olympics::Models::Event.create(:name => "class-color", :prettyname => "Class Color and Can Drive")
				Olympics::Models::Event.create(:name => "spirit-week", :prettyname => "Spirit Week")
				"ok"
			else
				"all events already exist"
			end
		end
		get '/api/scores' do
			# Grabs score data
			events = Olympics::Models::Event.all

			freshman_score = 0
			sophomore_score = 0
			junior_score = 0
			senior_score = 0

			symbols_to_scorevars = {:freshman => freshman_score, :sophomore => sophomore_score, :junior => junior_score, :senior => senior_score}
			grades = [Olympics::Models::Grade.first(:freshman => true), Olympics::Models::Grade.first(:sophomore => true), Olympics::Models::Grade.first(:junior => true), Olympics::Models::Grade.first(:senior => true)]
			grades_to_symbols = {grades[0] => :freshman, grades[1] => :sophomore, grades[2] => :junior, grades[3] => :senior}

			events.each do |event|
				if event.firstplace != nil
					[:freshman, :sophomore, :junior, :senior].each do |grade_symbol|
						if event.firstplace.grade.attributes[grade_symbol]
							symbols_to_scorevars[grade_symbol] += 10
						end
						if event.secondplace.grade.attributes[grade_symbol]
							symbols_to_scorevars[grade_symbol] += 8
						end
						if event.thirdplace.grade.attributes[grade_symbol]
							symbols_to_scorevars[grade_symbol] += 6
						end
						if event.fourthplace.grade.attributes[grade_symbol]
							symbols_to_scorevars[grade_symbol] += 4
						end
					end
				end
			end

			grades.each do |grade|
				if grade.deducted_points != nil
					symbols_to_scorevars[grades_to_symbols[grade]] -= grade.deducted_points
				end
			end

			symbols_to_scorevars.to_json
		end
		post '/api/scores' do

			names_to_grades = {"Freshmen" => Olympics::Models::Grade.first(:freshman => true), 
								"Sophomores" => Olympics::Models::Grade.first(:sophomore => true),
								"Juniors" => Olympics::Models::Grade.first(:junior => true),
								"Seniors" => Olympics::Models::Grade.first(:senior => true)}

			# Updates scores for an event with a given ID
			event_name = params[:event]
			first_place = params[:firstplace]
			second_place = params[:secondplace]
			third_place = params[:thirdplace]
			fourth_place = params[:fourthplace]

			event = Olympics::Models::Event.first(:prettyname => event_name)

			event.firstplace = Olympics::Models::Firstplace.create(:event => event, :grade => names_to_grades[first_place], :time => DateTime.now)
			event.secondplace = Olympics::Models::Secondplace.create(:event => event, :grade => names_to_grades[second_place], :time => DateTime.now)
			event.thirdplace = Olympics::Models::Thirdplace.create(:event => event, :grade => names_to_grades[third_place], :time => DateTime.now)
			event.fourthplace = Olympics::Models::Fourthplace.create(:event => event, :grade => names_to_grades[fourth_place], :time => DateTime.now)
			event.save

			"ok"
		end
		get '/api/grades' do
			grades = Array.new
			grades.push(Olympics::Models::Grade.first(:freshman => true).to_json)
			grades.push(Olympics::Models::Grade.first(:sophomore => true).to_json)
			grades.push(Olympics::Models::Grade.first(:junior => true).to_json)
			grades.push(Olympics::Models::Grade.first(:senior => true).to_json)

			return grades.to_json
		end
		post '/api/deduct' do

			names_to_grades = {"Freshmen" => Olympics::Models::Grade.first(:freshman => true), 
								"Sophomores" => Olympics::Models::Grade.first(:sophomore => true),
								"Juniors" => Olympics::Models::Grade.first(:junior => true),
								"Seniors" => Olympics::Models::Grade.first(:senior => true)}

			gradename = params[:grade]
			points = params[:points]

			if names_to_grades[gradename].deducted_points != nil
				names_to_grades[gradename].deducted_points += points.to_i
			else
				names_to_grades[gradename].deducted_points = points.to_i
				deduction = Olympics::Models::DeductionEvent.create(:grade => names_to_grades[gradename], :points => points.to_i, :time => DateTime.now)
			end

			names_to_grades[gradename].save

			"ok"
		end
		post '/api/grade/:gradeid/delete' do
			grade = Olympics::Models::Grade.get(params[:gradeid])
			grade.destroy
			"ok"
		end


		def get_scores grade_symbol
			events_to_scores = Hash.new
			events = Olympics::Models::Event.all
			events.each do |event|
				if event.firstplace != nil
					# scores have been tabulated for this event
					if event.firstplace.grade.attributes[grade_symbol]
						events_to_scores[event.prettyname] = 10
					elsif event.secondplace.grade.attributes[grade_symbol]
						events_to_scores[event.prettyname] = 8
					elsif event.thirdplace.grade.attributes[grade_symbol]
						events_to_scores[event.prettyname] = 6
					elsif event.fourthplace.grade.attributes[grade_symbol]
						events_to_scores[event.prettyname] = 4
					end
				end
			end
			
			# Grab deducted points

			grade = Olympics::Models::Grade.first(grade_symbol => true)
			if grade.deducted_points == nil
				events_to_scores["Deducted points"] = 0
			else
				events_to_scores["Deducted points"] = grade.deducted_points
			end

			events_to_scores
		end

		get '/api/freshman' do
			get_scores(:freshman).to_json
		end

		get '/api/sophomore' do
			get_scores(:sophomore).to_json
		end

		get '/api/junior' do
			get_scores(:junior).to_json
		end

		get '/api/senior' do
			get_scores(:senior).to_json
		end

		get '/entry' do
			if session[:authtoken] != "authtoken"
				redirect '/login'
			else
				erb :entry
			end
			# display form
		end
		post '/entry' do
			# handle form data
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

		get '/' do
			# scoreboard
			erb :scoreboard
		end

		get '/manager' do
				if session[:authtoken] != "authtoken"
					erb :login
				else
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
			end
			post '/manager' do
				# Updates classes using form data
				forms = params[:data]

				# Update freshmen

				freshman_data = forms["0"]
				freshman_grade = Olympics::Models::Grade.first(:freshman => true)
				if freshman_grade == nil
					freshman_grade = Olympics::Models::Grade.create(:deducted_points => 0, :year => freshman_data[:year], :colorhex => freshman_data[:color], :theme => freshman_data[:theme],
																	:freshman => true, :sophomore => false, :junior => false, :senior => false)
				else
					freshman_grade.year = freshman_data[:year]
					freshman_grade.colorhex = freshman_data[:color]
					freshman_grade.theme = freshman_data[:theme]
					freshman_grade.save
				end

				sophomore_data = forms["1"]
				sophomore_grade = Olympics::Models::Grade.first(:sophomore => true)
				if sophomore_grade == nil
					sophomore_grade = Olympics::Models::Grade.create(:deducted_points => 0, :year => sophomore_data[:year], :colorhex => sophomore_data[:color], :theme => sophomore_data[:theme],
																	:freshman => false, :sophomore => true, :junior => false, :senior => false)
				else
					sophomore_grade.year = sophomore_data[:year]
					sophomore_grade.colorhex = sophomore_data[:color]
					sophomore_grade.theme = sophomore_data[:theme]
					sophomore_grade.save
				end

				junior_data = forms["2"]
				junior_grade = Olympics::Models::Grade.first(:junior => true)
				if junior_grade == nil
					junior_grade = Olympics::Models::Grade.create(:deducted_points => 0, :year => junior_data[:year], :colorhex => junior_data[:color], :theme => junior_data[:theme],
																:freshman => false, :sophomore => false, :junior => true, :senior => false)
				else
					junior_grade.year = junior_data[:year]
					junior_grade.colorhex = junior_data[:color]
					junior_grade.theme = junior_data[:theme]
					junior_grade.save
				end

				senior_data = forms["3"]
				senior_grade = Olympics::Models::Grade.first(:senior => true)
				if senior_grade == nil
					senior_grade = Olympics::Models::Grade.create(:deducted_points => 0, :year => senior_data[:year], :colorhex => senior_data[:color], :theme => senior_data[:theme],
																 :freshman => false, :sophomore => false, :junior => false, :senior => true)
				else
					senior_grade.year = senior_data[:year]
					senior_grade.colorhex = senior_data[:color]
					senior_grade.theme = senior_data[:theme]
					senior_grade.save
				end

				"ok"
			end

		# use Olympics::Routes::API
		# use Olympics::Routes::Entry
		# use Olympics::Routes::Login
		# use Olympics::Routes::Scoreboard
		# use Olympics::Routes::Manager

	end
end

# Olympics::App.run!