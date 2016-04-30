require 'tumugi/target'

module Tumugi
  class FileTarget < Target
    Tumugi::Plugin.register_target(:file, self)

    def initialize(path)
      @path = path
    end

    attr_reader :path

    def exist?
      ::File.exist?(path)
    end
  end
end
