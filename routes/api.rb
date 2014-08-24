# Score entry API
# (for realtime capabilities)
# AJAX backend

require 'sinatra'

module Olympics
	module Routes
		class API < Sinatra::Application
			post '/api/score/:eventid' do
				# Updates scores for an event with a given ID

			end
			get '/api/scores' do
				# Grabs score data
				
			end
			post '/api/grade/:gradeid/delete' do
				grade = Olympics::Models::Grade.get(params[:gradeid])
				grade.destroy
				"ok"
			end
		end
	end
end