# Score entry API
# (for realtime capabilities)
# AJAX backend

require 'json'
require 'sinatra'

module Olympics
	module Routes
		class API < Sinatra::Application
			get '/api/scores' do
				# Grabs score data
				
			end
			post '/api/scores' do
				# Updates scores for an event with a given ID

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