source 'https://rubygems.org'

gem 'sinatra'

group :development, :test do
	gem "sqlite3"
	gem "dm-sqlite-adapter"
end

group :production do
	gem "pg"
	gem "dm-migrations"
	gem "dm-postgres-adapter"
end