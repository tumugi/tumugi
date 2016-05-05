require 'tumugi/parameter/parameter_proxy'

module Tumugi
  module Mixin
    module Parameterizable
      def self.included(mod)
        mod.extend(ClassMethods)
      end

      def initialize
        super()
        proxy = self.class.merged_parameter_proxy
        proxy.params.each do |name, param|
          instance_variable_set("@#{name}", param.get)
        end
      end

      module ClassMethods
        def parameter_proxy_map
          map = {}
          self.define_singleton_method(:parameter_proxy_map) { map }
          map
        end

        def parameter_proxy(mod_name)
          map = parameter_proxy_map
          unless map[mod_name]
            proxy = Tumugi::Parameter::ParameterProxy.new(mod_name)
            map[mod_name] = proxy
          end
          map[mod_name]
        end

        def param(name, opts={})
          parameter_proxy(proxy_id(self)).param(name, opts)
          attr_accessor name
        end

        def merged_parameter_proxy
          parameterizable = ancestors.reverse.select{ |a| a.respond_to?(:parameter_proxy) }
          parameterizable.map { |a| a.parameter_proxy(proxy_id(a)) }.reduce(:merge)
        end

        def dump
          parameter_proxy_map[proxy_id(self)].dump
        end

        def proxy_id(klass)
          self.name || self.object_id.to_s
        end
      end
    end
  end
end
