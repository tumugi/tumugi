require 'fileutils'
require 'erubis'

module Tumugi
  module Command
    class New
      def execute(name, options={})
        full_project_name = "tumugi-plugin-#{name}"
        templates = [
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

        @data_dir = "#{File.expand_path(File.dirname(__FILE__))}/../data/new"
        @dest_dir = "#{(options[:path] || '.')}/#{full_project_name}"
        if File.exist?(@dest_dir)
          puts "#{@dest_dir} is already exists. Please delete it first"
          return false
        end

        puts "Create #{@dest_dir}"
        FileUtils.mkdir_p(@dest_dir)

        templates.each do |value|
          src_file, dest_file = value
          eruby = Erubis::Eruby.new(File.read(src_path(src_file)))
          eruby.filename = src_path(src_file)
          context = {
            full_project_name: full_project_name,
            name: name,
            tumugi_version: Tumugi::VERSION,
          }
          puts "  Create #{dest_path(dest_file)}"
          FileUtils.mkdir_p(File.dirname(dest_path(dest_file)))
          File.write(dest_path(dest_file), eruby.result(context))
        end

        puts ""
        puts "Plugin template is successfully generated."
        puts "Next steps:"
        puts ""
        puts "  $ cd #{full_project_name}"
        puts "  $ git init"
        puts "  $ bundle install"
        puts "  $ bundle exec rake"
        puts ""

        return true
      end

      private

      def src_path(file)
        "#{@data_dir}/#{file}"
      end

      def dest_path(file)
        "#{@dest_dir}/#{file}"
      end
    end
  end
end
