require 'bundler/setup'
require 'active_record'
require_all 'models'
require './server'

run Sinatra::Application