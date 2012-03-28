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

# Start our own redis-server
REDIS_BIN  = 'redis-server'
REDIS_PORT = ENV['REDIS_PORT'] || 6379
REDIS_HOST = ENV['REDIS_HOST'] || 'localhost'
REDIS_PID  = File.expand_path 'redis.pid', File.dirname(__FILE__)
REDIS_DUMP = File.expand_path 'redis.rdb', File.dirname(__FILE__)
puts "=> Starting redis-server on #{REDIS_HOST}:#{REDIS_PORT}"

fork_pid = fork do
  system "(echo port #{REDIS_PORT}; echo logfile /dev/null; echo daemonize yes; echo pidfile #{REDIS_PID}; echo dbfilename #{REDIS_DUMP}) | #{REDIS_BIN} -"
end

at_exit do
  pid = File.read(REDIS_PID).to_i
  puts "=> Killing #{REDIS_BIN} with pid #{pid}"
  Process.kill "TERM", pid
  Process.kill "KILL", pid
  File.unlink REDIS_PID
end

#connect to redis
Redis.current = Redis.new(:host => REDIS_HOST, :port => REDIS_PORT)

# load test schema
load File.dirname(__FILE__) + '/support/schema.rb'
# load test models
load File.dirname(__FILE__) + '/support/models.rb'
# load test data
load File.dirname(__FILE__) + '/support/data.rb'

RSpec.configure do |config|
end
