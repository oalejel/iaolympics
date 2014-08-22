require 'data_mapper'

DataMapper.setup(:default, "sqlite:///#{Dir.pwd}/olympics.db")

Dir.glob('./models/*.rb').each do |file|
	load file
end

DataMapper.finalize
DataMapper.auto_upgrade!