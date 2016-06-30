require_relative './test_helper'
require 'tumugi/dag_result_reporter'

class Tumugi::DAGResultReporterTest < Test::Unit::TestCase
  setup do
    @reporter = Tumugi::DAGResultReporter.new
    @dag = Tumugi::DAG.new
  end

  test '#show' do
    report = @reporter.show(@dag)
    assert_equal("Workflow Result", report.title)
    head = report.headings.first
    assert_equal(4, head.cells.size)
    assert_equal("Task", head.cells[0].value)
    assert_equal("Requires", head.cells[1].value)
    assert_equal("Parameters", head.cells[2].value)
    assert_equal("State", head.cells[3].value)
  end
end
