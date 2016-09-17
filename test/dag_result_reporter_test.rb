require_relative './test_helper'
require 'tumugi/dag_result_reporter'

class Tumugi::DAGResultReporterTest < Test::Unit::TestCase
  class TestTask < Tumugi::Task
    param :param1, type: :string, default: "value1"
    param :param2, type: :time, default: Time.parse("2016-06-01 09:00:00 UTC")

    def requires
      TestTask2.new
    end
  end

  class TestTask2 < Tumugi::Task
    param :long_param, type: :string, default: "a"*26
    param :secure_param, type: :string, default: "secure", secure: true
  end

  setup do
    @reporter = Tumugi::DAGResultReporter.new
    @dag = Tumugi::DAG.new
    @task = TestTask.new
    @task.trigger!(:skip)
    @dag.add_task(@task)
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

    rows = report.rows
    assert_equal(2, rows.size)
    assert_equal("Tumugi::DAGResultReporterTest::TestTask2", rows[0].cells[0].value)
    assert_equal("", rows[0].cells[1].value)
    assert_equal("long_param=aaaaaaaaaaaaaaaaaaaaaaaaa...\nsecure_param=***", rows[0].cells[2].value)
    assert_equal(:pending, rows[0].cells[3].value)

    assert_equal("Tumugi::DAGResultReporterTest::TestTask", rows[1].cells[0].value)
    assert_equal("Tumugi::DAGResultReporterTest::TestTask2", rows[1].cells[1].value)
    assert_equal("param1=value1\nparam2=2016-06-01 09:00:00 UTC", rows[1].cells[2].value)
    assert_equal(:skipped, rows[1].cells[3].value)
  end
end
