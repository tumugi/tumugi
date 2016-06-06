require_relative '../test_helper'
require 'tumugi/plugin/file_system_target'

class Tumugi::Plugin::FileSystemTargetTest < Test::Unit::TestCase
  setup do
    @path = '/path/to/file'
    @target = Tumugi::Plugin::FileSystemTarget.new(@path)
  end

  test "initialize" do
    assert_equal(@path, @target.path)
  end

  test "raise_error when call fs" do
    assert_raise(NotImplementedError) do
      @target.fs
    end
  end

  test "to_s" do
    assert_equal(@path, @target.to_s)
  end
end
