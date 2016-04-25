require 'gviz'
require 'tmpdir'
require 'fileutils'

module Tumugi
  module Command
    class Show
      @@supported_formats = ['dot', 'png', 'jpg', 'svg', 'pdf']

      def execute(dag, options={})
        out = options[:out]
        if out
          ext = File.extname(options[:out])
          format = ext[1..-1] if ext.start_with?('.')
          raise "#{format} is not supported format" unless @@supported_formats.include?(format)
        else
          format = options[:format]
        end

        graph = Graph do
          dag.tsort.each do |task|
            node task.id
            route task.id => task._requires.map {|t| t.id}
          end
        end

        if out.present?
          Dir.mktmpdir do |dir|
            file_base_path = "#{File.dirname(dir)}/#{File.basename(out, '.*')}"
            graph.save(file_base_path, format == 'dot' ? nil : format)
            FileUtils.mkdir_p(File.dirname(out))
            FileUtils.copy("#{file_base_path}.#{format}", out)
          end
        else
          print graph
        end
      end
    end
  end
end
