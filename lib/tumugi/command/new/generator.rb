require 'fileutils'
require 'erubis'

module Tumugi
  module Command
    class New
      class Generator
        attr_reader :name, :options

        def initialize(name, options={})
          @name = name
          @options = options
        end

        def generate
          if File.exist?(dest_dir)
            logger.error "#{dest_dir} is already exists. Please delete it first"
            return false
          end

          logger.info "Create #{dest_dir}"
          FileUtils.mkdir_p(dest_dir)

          templates.each do |value|
            src_file, dest_file = value
            eruby = Erubis::Eruby.new(File.read(src_path(src_file)))
            eruby.filename = src_path(src_file)
            logger.info "  Create #{dest_path(dest_file)}"
            FileUtils.mkdir_p(File.dirname(dest_path(dest_file)))
            File.write(dest_path(dest_file), eruby.result(context))
          end

          unless post_messages.empty?
            post_messages.each{|msg| logger.info msg }
          end

          true
        end

        def data_dir
          nil
        end

        def dest_dir
          nil
        end

        def templates
          []
        end

        def context
          {}
        end

        def post_messages
          []
        end

        def logger
          @logger ||= Tumugi::ScopedLogger.new("tumugi-new")
        end

        private

        def src_path(file)
          "#{data_dir}/#{file}"
        end

        def dest_path(file)
          "#{dest_dir}/#{file}"
        end
      end
    end
  end
end
