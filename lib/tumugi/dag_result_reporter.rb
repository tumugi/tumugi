require 'terminal-table'

require 'tumugi/mixin/listable'

module Tumugi
  class DAGResultReporter
    include Tumugi::Mixin::Listable

    def show(dag)
      headings = ['Task', 'Requires', 'Parameters', 'State']
      Terminal::Table.new title: "Workflow Result", headings: headings do |t|
        dag.tsort.map.with_index do |task, index|
          proxy = task.class.merged_parameter_proxy
          requires = list(task.requires).map do |r|
            r.id
          end
          params = proxy.params.map do |name, param|
            val = param.secret? ? '***' : truncate(task.send(name.to_sym).to_s, 25)
            "#{name}=#{val}"
          end
          t << :separator if index != 0
          t << [ task.id, requires.join("\n"), params.join("\n"), task.state ]
        end
      end
    end

    private

    def truncate(text, length)
      return nil if text.nil?
      if text.length <= length
        text
      else
        text[0, length].concat('...')
      end
    end
  end
end
