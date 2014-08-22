require 'data_mapper'

module Olympics
	module Models
		class Event
			include DataMapper::Resource

			property :id, Serial
			property :name, String

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
		end

		class Secondplace
			include DataMapper::Resource

			# Represents a second place performance
			belongs_to :grade, :key => true
			belongs_to :event, :key => true
		end


		class Thirdplace
			include DataMapper::Resource

			belongs_to :grade, :key	=> true
			belongs_to :event, :key => true
		end

		class Fourthplace
			include DataMapper::Resource

			belongs_to :grade, :key => true
			belongs_to :grade, :key => true
		end
	end
end