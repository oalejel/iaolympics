require 'data_mapper'

module Olympics
	module Models
		class Grade
			# Represents a class of IA students, e.g. the class of 2015
			# To avoid confusion with the word "class", the word "grade" is used
		
			property :year, Integer
			property :name, String # seniors, juniors, etc.
			property :colorhex, String # e.g. black would be 000000
			property :theme, String

		end
	end
end