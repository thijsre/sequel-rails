source 'https://rubygems.org'

gemspec

gem 'actionpack'
gem 'fakefs', '0.5.3', :require => 'fakefs/safe'

gem 'pry'

# MRI/Rubinius Adapter Dependencies
platform :ruby do
  gem 'pg'
  if RUBY_VERSION < '2.4'
    gem 'mysql'
  end
  gem 'mysql2'
  gem 'sqlite3'
end

# JRuby Adapter Dependencies
platform :jruby do
  gem 'jdbc-sqlite3'
  gem 'jdbc-mysql'
  gem 'jdbc-postgres'
end
