require_relative './new/plugin_generator'
require_relative './new/project_generator'

module Tumugi
  module Command
    class New
      def execute(type, name, options={})
        generator = create_generator(type, name, options)
        generator.generate
      end

      def logger
        @logger ||= Tumugi::ScopedLogger.new("tumugi-new")
      end

      def create_generator(type, name, options)
        case type
        when "plugin"
          PluginGenerator.new(name, options)
        when "project"
          ProjectGenerator.new(name, options)
        else
          raise Tumugi::TumugiError.new("Unsupported type of new sub command: #{type}")
        end
      end
    end
  end
end
