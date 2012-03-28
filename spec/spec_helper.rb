$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'bundler'

Bundler.setup(:default, :development)

require 'rails'
require 'active_record'
require 'statable'
require 'rspec'

root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

Dir.mkdir("#{root}/db") unless File.directory?("#{root}/db")

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "#{root}/db/statable.db")

# load test schema
load File.dirname(__FILE__) + '/support/schema.rb'

RSpec.configure do |config|
end
