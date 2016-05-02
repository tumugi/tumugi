require 'tumugi/plugin'

module Tumugi
  module Mixin
    module TaskHelper
      def target(type, *args)
        klass = Tumugi::Plugin.lookup_target(type)
        klass.new(*args)
      end
    end
  end
end
