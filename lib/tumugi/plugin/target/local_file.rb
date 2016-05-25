require 'tumugi/plugin/atomic_local_file'
require 'tumugi/plugin/file_system_target'
require 'tumugi/plugin/local_file_system'

module Tumugi
  module Plugin
    class LocalFileTarget < FileSystemTarget
      Plugin.register_target('local_file', self)

      def fs
        @fs ||= LocalFileSystem.new
      end

      def open(mode="r", &block)
        if mode.include? 'r'
          File.open(path, mode, &block)
        elsif mode.include? 'w'
          AtomicLocalFile.new(path).open(&block)
        else
          raise 'Invalid mode: #{mode}'
        end
      end
    end
  end
end
