source 'https://rubygems.org'

gem 'sinatra'
gem 'json'

group :development, :test do
	gem "sqlite3"
	gem "dm-sqlite-adapter"
	gem "dm-migrations"
	gem "dm-serializer"
end

group :production do
	gem "pg"
	gem "dm-migrations"
	gem "dm-postgres-adapter"
	gem "dm-serializer"
end