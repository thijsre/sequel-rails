source 'https://rubygems.org'

gemspec

gem 'actionpack'
gem 'fakefs', '0.5.3', :require => 'fakefs/safe'

if RUBY_VERSION < '1.9'
  # why do we even care, it's deprecated
  gem 'activesupport', '< 4'
  gem 'pry', '< 0.10'
  gem 'tzinfo'
else
  gem 'pry'
end

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
