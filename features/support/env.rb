PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../../config/boot")
ENV['RACK_ENV'] = 'test'
require 'bundler/setup'


##
# You can handle all padrino applications using instead:
#   Padrino.application
Capybara.app = TwitterClone.tap { |app|  }require 'capybara'
require 'capybara/cucumber'
require 'capybara-webkit'
require 'test/unit/assertions'
require 'database_cleaner'
require 'database_cleaner/cucumber'

DatabaseCleaner.strategy = :truncation

Capybara.app = TwitterClone
Capybara.javascript_driver = :webkit

class TwitterCloneWorld
  include Capybara::DSL
  include Test::Unit::Assertions
end

Before do
  DatabaseCleaner.start
  User.create(handle: "BigAl", following: [])
  User.create(handle: "-__-", following: ["BigAl"])
end

After do
  DatabaseCleaner.clean
end

World do
  TwitterCloneWorld.new
end

