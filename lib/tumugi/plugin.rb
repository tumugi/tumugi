require 'tumugi'
require 'tumugi/registry'

module Tumugi
  module Plugin
    TARGET_REGISTRY = Registry.new(:target, 'tumugi/plugin/target/')
    TASK_REGISTRY   = Registry.new(:task,   'tumugi/plugin/task/')

    def self.register_target(type, klass)
      register_impl('target', TARGET_REGISTRY, type, klass)
    end

    def self.register_task(type, klass)
      register_impl('task', TASK_REGISTRY, type, klass)
    end

    def self.register_impl(kind, registry, type, value)
      if !value.is_a?(Class)
        raise "Invalid implementation as #{kind} plugin: '#{type}'. It must be a Class."
      end
      registry.register(type, value)
      Tumugi::Logger.instance.debug "registered #{kind} plugin '#{type}'"
      nil
    end

    def self.lookup_target(type)
      lookup_impl('target', TARGET_REGISTRY, type)
    end

    def self.lookup_task(type)
      lookup_impl('task', TASK_REGISTRY, type)
    end

    def self.lookup_impl(kind, registry, type)
      obj = registry.lookup(type)
      if obj.is_a?(Class)
        obj
      else
        raise "#{kind} plugin '#{type}' is not a Class"
      end
    end
  end
end
