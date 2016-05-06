require 'tumugi/parameter/error'
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
        params = proxy.params
        proxy.param_defaults.each do |name, value|
          param = params[name]
          param.overwrite_default(value) if param
        end
        params.each do |name, param|
          unless proxy.param_auto_bind_enabled.nil?
            param.task_param_auto_bind_enabled = proxy.param_auto_bind_enabled
          end
          instance_variable_set("@#{name}", param.get)
        end
        validate_params(params)
        configure
      end

      def validate_params(params)
        params.each do |name, param|
          if param.required? && instance_variable_get("@#{name}").nil?
            raise Tumugi::Parameter::ParameterError.new("Parameter #{name} is required")
          end
        end
      end

      def configure
        # You can override in a subclass
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

        def param_set(name, value)
          parameter_proxy(proxy_id(self)).param_set(name, value)
        end

        def param_auto_bind_enabled(v)
          parameter_proxy(proxy_id(self)).param_auto_bind_enabled = v
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
