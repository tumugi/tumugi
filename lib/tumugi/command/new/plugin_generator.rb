require_relative 'generator'

module Tumugi
  module Command
    class New
      class PluginGenerator < Generator
        def data_dir
          "#{File.expand_path(File.dirname(__FILE__))}/../../data/new/plugin"
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
    end
  end
end
