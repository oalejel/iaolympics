# Score entry API
# (for realtime capabilities)
# AJAX backend

require 'json'
require 'sinatra'

module Olympics
	module Routes
		class API < Sinatra::Application
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
				else
					"events already exist"
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
				grades_to_symbols = {grades[0] => :freshman, grades[1] => :sophomores, grades[2] => :juniors, grades[3] => :seniors}

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

				event.firstplace = Olympics::Models::Firstplace.create(:event => event, :grade => names_to_grades[first_place])
				event.secondplace = Olympics::Models::Secondplace.create(:event => event, :grade => names_to_grades[second_place])
				event.thirdplace = Olympics::Models::Thirdplace.create(:event => event, :grade => names_to_grades[third_place])
				event.fourthplace = Olympics::Models::Fourthplace.create(:event => event, :grade => names_to_grades[fourth_place])
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
				end

				names_to_grades[gradename].save

				"ok"
			end
			post '/api/grade/:gradeid/delete' do
				grade = Olympics::Models::Grade.get(params[:gradeid])
				grade.destroy
				"ok"
			end


			get '/api/freshman' do
				events_to_scores = Hash.new
				events = Event.all
				events.each do |event|
					if event.firstplace.grade.freshman
						events_to_scores[event] = 10
					elsif event.secondplace.grade.freshman
						events_to_scores[event] = 8
					elsif event.thirdplace.grade.freshman
						events_to_scores[event] = 6
					elsif event.fourthplace.grade.freshman
						events_to_scores[event] = 4
					end
				end
				events_to_scores.to_json
			end

			get '/api/sophomore' do
				events_to_scores = Hash.new
				events = Event.all
				events.each do |event|
					if event.firstplace.grade.sophomore
						events_to_scores[event] = 10
					elsif event.secondplace.grade.sophomore
						events_to_scores[event] = 8
					elsif event.thirdplace.grade.sophomore
						events_to_scores[event] = 6
					elsif event.fourthplace.grade.sophomore
						events_to_scores[event] = 4
					end
				end
				events_to_scores.to_json
			end

			get '/api/junior' do
				events_to_scores = Hash.new
				events = Event.all
				events.each do |event|
					if event.firstplace.grade.junior
						events_to_scores[event] = 10
					elsif event.secondplace.grade.junior
						events_to_scores[event] = 8
					elsif event.thirdplace.grade.junior
						events_to_scores[event] = 6
					elsif event.fourthplace.grade.junior
						events_to_scores[event] = 4
					end
				end
				events_to_scores.to_json
			end

			get '/api/senior' do
				events_to_scores = Hash.new
				events = Event.all
				events.each do |event|
					if event.firstplace.grade.senior
						events_to_scores[event] = 10
					elsif event.secondplace.grade.senior
						events_to_scores[event] = 8
					elsif event.thirdplace.grade.senior
						events_to_scores[event] = 6
					elsif event.fourthplace.grade.senior
						events_to_scores[event] = 4
					end
				end
				events_to_scores.to_json
			end
		end
	end
end