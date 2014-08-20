require 'data_mapper'

module Olympics
	module Models
		class Event
			include DataMapper::Event

			property :name, String

			has 1, :firstplace
			has 1, :secondplace
			has 1, :thirdplace
			has 1, :fourthplace

		end

		class FirstPlace
			# Represents a first place win
			belongs_to :grade, :key => true
			belongs_to :event, :key => true
		end

		class SecondPlace
			# Represents a second place performance
			belongs_to :grade, :key => true
			belongs_to :event, :key => true
		end


		class ThirdPlace
			belongs_to :grade, :key	=> true
			belongs_to :event, :key => true
		end

		class FourthPlace
			belongs_to :grade, :key => true
			belongs_to :grade, :key => true
		end
	end
end