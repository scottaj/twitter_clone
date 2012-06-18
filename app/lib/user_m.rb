require 'mongoid'

class User
  include Mongoid::Document
  field :handle, type: String
  field :following, type: Array
end
