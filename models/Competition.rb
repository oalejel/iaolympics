require 'data_mapper'

module Olympics
	module Models
		class Competition
			# Represents an olympics competition (the annual holding of olympics)
			# So there would be a separate instance for the 2014 olympics, 2015 olympics, etc.

			include DataMapper::Resource

			property :id, Serial
			property :year, Integer

			has n, :events
		end
	end
end