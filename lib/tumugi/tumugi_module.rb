require 'tumugi/application'
require 'tumugi/config'
require 'tumugi/logger'

module Tumugi
  class << self
    def application
      @application ||= Tumugi::Application.new
    end

    def logger
      @logger ||= Tumugi::Logger.new
    end

    def config
      @config ||= Tumugi::Config.new
      if block_given?
        yield @config
      end
      @config
    end
  end
end
