# Path to your real ruby(sinatra) application
require File.join(File.dirname(__FILE__), '..', 'main.rb')
 
require 'rubygems'
require 'sinatra'
require 'rspec'
require 'rack/test'
require "rack/mock_session"
require 'mongo_mapper'
require 'factory_girl'
FactoryGirl.find_definitions

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false
 
# For testing models
# reset the database before each test to make sure our tests don't influence one another
RSpec.configure do |config|
  config.before(:each) do
    MongoMapper.connection = Mongo::Connection.new('localhost', 27017)
    MongoMapper.database = "fanhattan_blog_test"
  end

  config.after(:each) do
    MongoMapper.connection.drop_database("fanhattan_blog_test")
  end
end

use Rack::Session::Cookie, :key => 'fanhattan_admin', :secret => '51d6d976913ace58'
