require 'tsort'
require 'tumugi/helper'

module Tumugi
  class DAG
    include TSort
    include Tumugi::Helper

    def initialize
      @tasks = {}
    end

    def tsort_each_node(&block)
      @tasks.each_key(&block)
    end

    def tsort_each_child(node, &block)
      @tasks.fetch(node).each(&block)
    end

    def add_task(task)
      t = task.instance
      unless @tasks[t]
        reqs = list(t.requires).map {|r| r.instance }
        @tasks[t] = reqs
        reqs.each do |r|
          add_task(r)
        end
      end
      task
    end
  end
end
