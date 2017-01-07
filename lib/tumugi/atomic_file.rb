require 'tempfile'
require 'forwardable'

module Tumugi
  class AtomicFile
    extend Forwardable
    def_delegators :@temp_file,
      :bin_mode?, :print, :printf, :putc, :puts, :write,
      :seek, :set_encoding, :sync, :sync=, :sysseek,
      :syswrite, :write, :write_nonblock, :flush

    def initialize(path)
      @path = path
    end

    attr_reader :path

    def open(&block)
      if block_given?
        Tempfile.open(basename) do |fp|
          @temp_file = fp
          block.call(self)
          close
        end
      else
        @temp_file = Tempfile.open(basename)
      end
      self
    end

    def close
      if @temp_file
        @temp_file.flush
        move_to_final_destination(@temp_file)
        @temp_file.close
        @temp_file = nil
      end
    end

    def move_to_final_destination(temp_file)
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end

    private

    def basename
      @basename ||= File.basename(@path)
    end
  end
end
