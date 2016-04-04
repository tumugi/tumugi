require 'tumugi/application'

module Tumugi
  class << self
    def application
      @application ||= Tumugi::Application.new
    end
  end
end
