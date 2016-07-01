require 'tumugi/workflow'
require 'tumugi/config'
require 'tumugi/error'
require 'tumugi/logger'
require 'tumugi/version'

module Tumugi
  class << self
    def workflow
      @workflow ||= Tumugi::Workflow.new
    end
    # alias for backward compatibility
    alias_method :app, :workflow
    alias_method :application, :workflow

    def configure(&block)
      raise Tumugi::ConfigError.new 'Tumugi.configure must have block' unless block_given?
      yield _config
      nil
    end

    def config
      raise Tumugi::ConfigError.new 'Tumugi.config with block is deprecated. Use Tumugi.configure instead.' if block_given?
      _config.clone.freeze
    end

    private

    def _config
      @config ||= Tumugi::Config.new
    end
  end
end
