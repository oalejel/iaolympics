require 'data_mapper'

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

			# One of these must be true

			property :freshman, Boolean
			property :sophomore, Boolean
			property :junior, Boolean
			property :senior, Boolean

		end
	end
end