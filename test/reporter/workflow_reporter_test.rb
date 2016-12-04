require_relative '../test_helper'
require 'tumugi/workflow'
require 'tumugi/reporter/workflow_reporter'

class Tumugi::Reporter::WorkflowReporterTest < Test::Unit::TestCase
  setup do
    @workflow = Tumugi::Workflow.new
    @reporter = Tumugi::Reporter::WorkflowReporter.new(@workflow)
  end

  test '#report' do
    result = @reporter.report
    assert_equal(result, {
      id: @workflow.id,
      success: false,
      start_time: @workflow.start_time.iso8609
    })
  end
end
