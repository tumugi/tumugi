require 'tumugi/error'
require 'tumugi/logger'
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
        params = proxy.params.dup
        proxy.param_defaults.each do |name, value|
          if params[name]
            params[name] = params[name].merge_default_value(value)
          end
        end
        params.each do |name, param|
          unless proxy.param_auto_bind_enabled.nil?
            param.task_param_auto_bind_enabled = proxy.param_auto_bind_enabled
          end
          instance_variable_set("@#{name}", param.get)
        end
        validate_params(proxy.params)
        configure
      end

      def validate_params(params)
        params.each do |name, param|
          if param.required? && instance_variable_get("@#{name}").nil?
            raise Tumugi::ParameterError.new("Parameter #{name} is required")
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
          parameter_proxy(proxy_id).param(name, opts)
          attr_writer name
          define_method(name) do
            val = self.instance_variable_get("@#{name}")
            if val.instance_of?(Proc)
              v = self.instance_exec(&val)
              self.instance_variable_set("@#{name}", v)
              v
            else
              val
            end
          end
        end

        def set(name, value)
          parameter_proxy(proxy_id).set(name, value)
        end

        def param_set(name, value)
          Tumugi::Logger.instance.warn("'param_set' is deprecated and will be removed in a future release. Use 'set' instead.")
          set(name, value)
        end

        def param_auto_bind_enabled(v)
          parameter_proxy(proxy_id).param_auto_bind_enabled = v
        end

        def merged_parameter_proxy
          parameterizables = ancestors.reverse.select{ |a| a.respond_to?(:parameter_proxy) }
          parameterizables.map { |a| a.parameter_proxy(a.proxy_id) }.reduce(:merge)
        end

        def dump
          parameter_proxy_map[proxy_id].dump
        end

        def proxy_id
          self.name || self.object_id.to_s
        end
      end
    end
  end
end
