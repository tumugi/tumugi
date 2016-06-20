require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'test/unit'
require 'test/unit/rr'

require 'tumugi'
require 'tumugi/plugin'
require 'tumugi/test/helper'
include Tumugi::Test::Helpers

Dir.mkdir('tmp') unless Dir.exist?('tmp')

Tumugi::Logger.instance.init

module Tumugi
  class Config
    def self.reset_config_sections
      @@sections = {}
    end
  end
end
