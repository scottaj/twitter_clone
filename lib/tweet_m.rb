require 'bundler/setup'
require 'mongoid'

class Tweet
  include Mongoid::Document
  field :text, type: String
  field :user, type: String
  field :timestamp, type: Time
  field :tags, type: Array
end
