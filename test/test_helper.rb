require 'simplecov'
require 'coveralls'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter '/test/'
  add_filter do |src|
    src.filename =~ /.*\.erb$/
  end
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'test/unit'
require 'test/unit/rr'

require 'tumugi'
require 'tumugi/plugin'
require 'tumugi/test/helper'
include Tumugi::Test::Helpers

Dir.mkdir('tmp') unless Dir.exist?('tmp')

Tumugi::Logger.instance.init
Tumugi::Logger.instance.quiet! unless ENV['DEBUG']

module Tumugi
  class Config
    def self.reset_config_sections
      @@sections = {}
    end
  end
end
