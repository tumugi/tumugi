require_relative 'generator'

module Tumugi
  module Command
    class New
      class ProjectGenerator < Generator
        def data_dir
          "#{File.expand_path(File.dirname(__FILE__))}/../../data/new/project"
        end

        def dest_dir
          File.join(options[:path] || '.', name)
        end

        def templates
          [
            [ "Gemfile.erb", "Gemfile" ],
            [ "workflow.rb.erb", "workflow.rb" ],
            [ "tumugi_config.rb.erb", "tumugi_config.rb" ],
          ]
        end

        def context
          {
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
            name.empty? ? "" : "  $ cd #{name}",
            "  $ bundle install",
            "  $ bundle exec tumugi -f workflow.rb main",
            "",
          ]
        end
      end
    end
  end
end
