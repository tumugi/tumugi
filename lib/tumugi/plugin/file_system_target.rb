require 'tumugi/target'
require 'tumugi/file_system'
require 'tumugi/error'

module Tumugi
  module Plugin
    class FileSystemTarget < Target
      attr_reader :path

      def initialize(path)
        @path = path
      end

      def fs
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def open(mode="r")
      end

      def exist?
        fs.exist?(@path)
      end

      def remove
        fs.remove(@path)
      end

      def to_s
        path
      end
    end
  end
end
