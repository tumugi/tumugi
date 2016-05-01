require 'tumugi/plugin'

module Tumugi
  module TaskMixin
    def target(type, *args)
      klass = Tumugi::Plugin.lookup_target(type)
      klass.new(*args)
    end
  end
end
