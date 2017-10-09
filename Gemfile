source 'https://rubygems.org'

gemspec

gem 'actionpack'
gem 'fakefs', '0.5.3', :require => 'fakefs/safe'

gem 'pry'

# MRI/Rubinius Adapter Dependencies
platform :ruby do
  gem 'mysql' if RUBY_VERSION < '2.4'
  gem 'mysql2'
  gem 'pg'
  gem 'sqlite3'
end

# JRuby Adapter Dependencies
platform :jruby do
  gem 'jdbc-mysql'
  gem 'jdbc-postgres'
  gem 'jdbc-sqlite3'
end
