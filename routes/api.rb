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
					a = Olympics::Models::Event.create(:name => "hallway", :prettyname => "Hallway")
					Olympics::Models::Event.create(:name => "tshirt", :prettyname => "T-shirt Contest")
					Olympics::Models::Event.create(:name => "class-banner", :prettyname => "Class Banner")
					Olympics::Models::Event.create(:name => "tug-of-war", :prettyname => "Tug of War")
					Olympics::Models::Event.create(:name => "oakland-county-500-race", :prettyname => "Oakland County 500 (Race)")
					Olympics::Models::Event.create(:name => "oakland-county-500-artistic", :prettyname => "Oakland County 500 (Artistic)")
					Olympics::Models::Event.create(:name => "watermelon-eating-contest", :prettyname => "Watermelon Eating Contest")
					Olympics::Models::Event.create(:name => "egg-toss", :prettyname => "Egg Toss")
					Olympics::Models::Event.create(:name => "four-legged-race", :prettyname => "Four Legged Race")
					Olympics::Models::Event.create(:name => "ac-surprise", :prettyname => "AC Surprise")
					Olympics::Models::Event.create(:name => "euchre", :prettyname => "Euchre")
					Olympics::Models::Event.create(:name => "chess", :prettyname => "Chess tournament")
					Olympics::Models::Event.create(:name => "trivial-pursuit", :prettyname => "Trivial pursuit")
					Olympics::Models::Event.create(:name => "team-ninja", :prettyname => "Team Ninja")
					Olympics::Models::Event.create(:name => "gladiator", :prettyname => "Gladiator")
					Olympics::Models::Event.create(:name => "millionaire", :prettyname => "Who Wants to be a Millionaire")
					Olympics::Models::Event.create(:name => "ultimate-frisbee", :prettyname => "Ultimate Frisbee")
					Olympics::Models::Event.create(:name => "volleyball", :prettyname => "Volleyball")
					Olympics::Models::Event.create(:name => "mural-contest", :prettyname => "Mural Contest")
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
				
			end
			post '/api/scores' do

				names_to_grades = {"freshmen" => Olympics::Models::Grade.first(:freshman => true), 
									"sophomores" => Olympics::Models::Grade.first(:sophomore => true),
									"juniors" => Olympics::Models::Grade.first(:junior => true),
									"seniors" => Olympics::Models::Grade.first(:senior => true)}

				# Updates scores for an event with a given ID
				event_name = params[:event]
				first_place = params[:firstplace]
				second_place = params[:secondplace]
				third_place = params[:thirdplace]
				fourth_place = params[:fourthplace]

				event = Olympics::Models::Event.first(:prettyname => event_name)
				event.firstplace = names_to_grades[first_place]
				event.secondplace = names_to_grades[second_place]
				event.thirdplace = names_to_grades[third_place]
				event.fourthplace = names_to_grades[fourth_place]
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
			post '/api/grade/:gradeid/delete' do
				grade = Olympics::Models::Grade.get(params[:gradeid])
				grade.destroy
				"ok"
			end
		end
	end
end