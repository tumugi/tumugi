require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'test/unit'
require 'test/unit/rr'

require 'tumugi'
require 'tumugi/plugin'

Dir.mkdir('tmp') unless Dir.exist?('tmp')

def capture_stdout
  out = StringIO.new
  $stdout = out
  yield
  return out.string
ensure
  $stdout = STDOUT
end

Tumugi::Logger.instance.init

module Tumugi
  class Config
    def self.reset_config_sections
      @@sections = {}
    end
  end
end
