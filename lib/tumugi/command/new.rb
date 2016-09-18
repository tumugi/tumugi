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

      class PluginGenerator < Generator
        def data_dir
          "#{File.expand_path(File.dirname(__FILE__))}/../data/new/plugin"
        end

        def dest_dir
          "#{(options[:path] || '.')}/#{full_project_name}"
        end

        def templates
          [
            [ "Gemfile.erb", "Gemfile" ],
            [ "gemspec.erb", "#{full_project_name}.gemspec" ],
            [ "gitignore.erb", ".gitignore" ],
            [ "Rakefile.erb", "Rakefile" ],
            [ "README.md.erb", "README.md" ],
            [ "examples/example.rb.erb", "examples/example.rb" ],
            [ "lib/tumugi/plugin/target/target.rb.erb", "lib/tumugi/plugin/target/#{name}.rb" ],
            [ "lib/tumugi/plugin/task/task.rb.erb", "lib/tumugi/plugin/task/#{name}.rb" ],
            [ "test/test_helper.rb.erb", "test/test_helper.rb" ],
            [ "test/test.rb.erb", "test/#{name}_test.rb" ],
            [ "test/plugin/target/target_test.rb.erb", "test/plugin/target/#{name}_test.rb" ],
            [ "test/plugin/task/task_test.rb.erb", "test/plugin/task/#{name}_test.rb" ],
          ]
        end

        def full_project_name
          "tumugi-plugin-#{name}"
        end

        def context
          {
            full_project_name: full_project_name,
            name: name,
            tumugi_version: Tumugi::VERSION,
          }
        end

        def post_messages
          [
            "",
            "Plugin template is successfully generated.",
            "Next steps:",
            "",
            "  $ cd #{full_project_name}",
            "  $ git init",
            "  $ bundle install",
            "  $ bundle exec rake",
            "",
          ]
        end
      end

      def execute(type, name, options={})
        generator = case type
                    when "plugin"
                      PluginGenerator.new(name, options)
                    else
                      raise Tumugi::TumugiError.new("Unsupported type of new sub command: #{type}")
                    end

        generator.generate
      end

      def logger
        @logger ||= Tumugi::ScopedLogger.new("tumugi-new")
      end
    end
  end
end
