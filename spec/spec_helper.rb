$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'bundler'

Bundler.setup(:default, :development)

require 'rails'
require 'active_record'

require 'redis'
require 'redis/objects'

require 'statable'

require 'rspec'

root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

Dir.mkdir("#{root}/db") unless File.directory?("#{root}/db")

# connect to sqlite
ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "#{root}/db/statable.db")

#connect to redis
Redis.current = Redis.new(:host => '127.0.0.1', :port => 6379)

# load test schema
load File.dirname(__FILE__) + '/support/schema.rb'
# load test models
load File.dirname(__FILE__) + '/support/models.rb'
# load test data
load File.dirname(__FILE__) + '/support/data.rb'

RSpec.configure do |config|
end
