require 'tumugi/event'
require 'tumugi/plugin'
require 'tumugi/task'
require 'tumugi/logger/logger'
require 'tumugi/mixin/listable'
require 'tumugi/mixin/task_helper'

module Tumugi
  class TaskDefinition
    include Tumugi::Mixin::Listable
    include Tumugi::Mixin::TaskHelper

    def self.define(id, opts={}, &block)
      td = Tumugi::TaskDefinition.new(id, opts)
      td.instance_eval(&block) if block_given?
      Tumugi.workflow.add_task(id, td)
      td
    end

    attr_reader :id, :opts

    def initialize(id, opts={})
      @id = id
      @opts = { type: Tumugi::Task }.merge(opts)
      @params = {}
      @param_defaults = {}
      define_parent_parameter_methods
    end

    def instance
      @task ||= create_task
    end

    def param(name, opts={})
      define_parameter_method(name)
      @params[name] = opts
    end

    def set(name, value=nil, &block)
      if block_given?
        @param_defaults[name] = block
      else
        @param_defaults[name] = value
      end
    end

    def param_set(name, value=nil, &block)
      Tumugi::Logger.instance.warn("'param_set' is deprecated and will be removed in a future release. Use 'set' instead.")
      set(name, value, &block)
    end

    def param_auto_bind_enabled(v)
      @param_auto_bind_enabled = v
    end

    def requires(tasks)
      @required_tasks = tasks
    end

    def output(outputs=[], &block)
      @outputs ||= (block || outputs)
    end

    def run(&block)
      @run = block
    end

    Event.all.each do |event|
      class_eval <<-EOS
        def on_#{event}(&block)
          @on_#{event} ||= block
        end
      EOS
    end

    def output_eval(task)
      @out ||= @outputs.is_a?(Proc) ? task.instance_eval(&@outputs) : @outputs
    end

    def required_tasks
      @required_tasks
    end

    def parent_task_class
      if @opts[:type].is_a?(Class)
        @opts[:type]
      else
        Tumugi::Plugin.lookup_task(@opts[:type])
      end
    end

    def run_block(task)
      task.instance_eval(&@run)
    end

    def event_block(task, callback)
      task.instance_eval(&callback)
    end

    private

    def create_task
      task = define_task.new
      raise "Invalid type: '#{@opts[:type]}'" unless task.is_a?(Tumugi::Task)
      task.id = @id
      task
    end

    def define_task
      task_class = Class.new(parent_task_class)
      define_requires_method(task_class)
      define_output_method(task_class)
      define_run_method(task_class)
      define_event_callback_methods(task_class)
      setup_params(task_class)
      task_class
    end

    def define_requires_method(task_class)
      td = self
      task_class.class_eval do
        define_method(:requires) do
          reqs = td.required_tasks
          if reqs.nil?
            []
          elsif reqs.is_a?(Array)
            reqs.map { |t| Tumugi.workflow.find_task(t) }
          elsif reqs.is_a?(Hash)
            Hash[reqs.map { |k, t| [k, Tumugi.workflow.find_task(t)] }]
          else
            Tumugi.workflow.find_task(reqs)
          end
        end
      end
    end

    def define_output_method(task_class)
      td = self
      task_class.class_eval do
        define_method(:output) do
          td.output_eval(self)
        end
      end unless @outputs.nil?
    end

    def define_run_method(task_class)
      td = self
      task_class.class_eval do
        define_method(:run) do
          td.run_block(self)
        end
      end unless @run.nil?
    end

    def define_event_callback_methods(task_class)
      td = self
      Event.all.each do |event|
        callback = instance_variable_get("@on_#{event}")
        if callback
          task_class.class_eval do
            define_method(:"on_#{event}") do
              td.event_block(self, callback)
            end
          end
        end
      end
    end

    def setup_params(task_class)
      @params.each do |name, opts|
        task_class.param(name, opts)
      end
      @param_defaults.each do |name, value|
        task_class.set(name, value)
      end
      unless @param_auto_bind_enabled.nil?
        task_class.param_auto_bind_enabled(@param_auto_bind_enabled)
      end
    end

    def define_parameter_method(name)
      instance_eval("def self.#{name}(value=nil, &block); set(:#{name}, value, &block); end")
    end

    def define_parent_parameter_methods
      proxy = parent_task_class.merged_parameter_proxy
      proxy.params.each do |name, _|
        define_parameter_method(name)
      end
    end
  end
end
