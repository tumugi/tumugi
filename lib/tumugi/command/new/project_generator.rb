require_relative 'generator'

module Tumugi
  module Command
    class New
      class ProjectGenerator < Generator
        def data_dir
          "#{File.expand_path(File.dirname(__FILE__))}/../../data/new/project"
        end

        def dest_dir
          "#{(options[:path] || '.')}/#{full_project_name}"
        end

        def templates
          [
            [ "Gemfile.erb", "Gemfile" ],
            [ "workflow.rb.erb", "workflow.rb" ],
            [ "tumugi_config.rb.erb", "tumugi_config.rb" ],
          ]
        end

        def full_project_name
          name
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
            "Project template is successfully generated.",
            "Next steps:",
            "",
            "  $ cd #{full_project_name}",
            "  $ git init",
            "  $ bundle install",
            "  $ bundle exec tumugi -f workflow.rb main",
            "",
          ]
        end
      end
    end
  end
end
