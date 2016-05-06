require 'tumugi/task'
require 'tumugi/plugin'
require 'tumugi/mixin/listable'
require 'tumugi/mixin/task_helper'

module Tumugi
  class TaskDefinition
    include Tumugi::Mixin::Listable
    include Tumugi::Mixin::TaskHelper

    def self.define(id, opts={}, &block)
      td = Tumugi::TaskDefinition.new(id, opts)
      td.instance_eval(&block) if block_given?
      Tumugi.application.add_task(id, td)
      td
    end

    attr_reader :id, :opts

    def initialize(id, opts={})
      @id = id
      @opts = { type: Tumugi::Task }.merge(opts)
      @params = {}
      @param_defaults = {}

      unless @opts[:type].is_a?(Class)
        @opts[:type] = Tumugi::Plugin.lookup_task(@opts[:type])
      end
    end

    def instance
      @task ||= create_task
    end

    def param(name, opts={})
      @params[name] = opts
    end

    def param_set(name, value)
      @param_defaults[name] = value
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

    def output_eval(task)
      @out ||= @outputs.is_a?(Proc) ? task.instance_eval(&@outputs) : @outputs
    end

    def required_tasks
      @required_tasks
    end

    def run_block(task)
      task.instance_eval(&@run)
    end

    private

    def create_task
      task = define_task.new
      raise "Invalid type: '#{@opts[:type]}'" unless task.is_a?(Tumugi::Task)
      task.id = @id
      task
    end

    def define_task
      task_class = Class.new(lookup_parent_task_class)
      define_requires_method(task_class)
      define_output_method(task_class)
      define_run_method(task_class)
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
            reqs.map { |t| Tumugi.application.find_task(t) }
          elsif reqs.is_a?(Hash)
            Hash[reqs.map { |k, t| [k, Tumugi.application.find_task(t)] }]
          else
            Tumugi.application.find_task(reqs)
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

    def setup_params(task_class)
      @params.each do |name, opts|
        task_class.param(name, opts)
      end
      @param_defaults.each do |name, value|
        task_class.param_set(name, value)
      end
      unless @param_auto_bind_enabled.nil?
        task_class.param_auto_bind_enabled(@param_auto_bind_enabled)
      end
    end

    def lookup_parent_task_class
      if @opts[:type].is_a?(Class)
        @opts[:type]
      else
        Tumugi::Plugin.lookup_task(@opts[:type])
      end
    end
  end
end
