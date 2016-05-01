require 'tumugi/target'

module Tumugi
  module Plugin
    class FileTarget < Target
      Plugin.register_target(:file, self)

      def initialize(path)
        @path = path
      end

      attr_reader :path

      def exist?
        ::File.exist?(path)
      end
    end
  end
end
