require 'tumugi/target/target'

module Tumugi
  module Target
    class FileTarget < Base
      attr_reader :path

      def initialize(path)
        @path = path
      end

      def exist?
        ::File.exist?(path)
      end
    end
  end
end
