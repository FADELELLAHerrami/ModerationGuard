require 'net/http'
require_relative './concerns/moderable'

class ModeratedModel < ApplicationRecord
  include Moderable
end
