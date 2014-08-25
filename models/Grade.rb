require 'data_mapper'

module Olympics
	module Models
		class Grade
			include DataMapper::Resource

			property :id, Serial

			# Represents a class of IA students, e.g. the class of 2015
			# To avoid confusion with the word "class", the word "grade" is used
		
			property :year, Integer
			property :colorhex, String # e.g. black would be 000000
			property :theme, String

		end

		class FreshmanGrade < Grade
			
		end

		class SophomoreGrade < Grade

		end

		class JuniorGrade < Grade

		end

		class SeniorGrade < Grade

		end	
	end
end