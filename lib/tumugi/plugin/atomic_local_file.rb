require 'fileutils'
require 'tumugi/atomic_file'

module Tumugi
  module Plugin
    class AtomicLocalFile < AtomicFile
      def move_to_final_destination(temp_file)
        FileUtils.move(temp_file, path)
      end
    end
  end
end
