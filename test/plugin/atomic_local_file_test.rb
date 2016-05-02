require_relative '../test_helper'
require 'tempfile'
require 'tumugi/plugin/atomic_local_file'

class Tumugi::Plugin::AtomicLocalFileTest < Test::Unit::TestCase
  setup do
    @path = "tmp/atomic_test_file_#{SecureRandom.uuid}"
    @file = Tumugi::Plugin::AtomicLocalFile.new(@path)
  end

  sub_test_case '#open' do
    test 'with block' do
      @file.open do |fp|
        fp.print 'success'
      end
      assert_equal('success', File.read(@path))
    end

    test 'without block' do
      fp = @file.open
      fp.print 'success'
      assert_false(File.exist?(@path))
      @file.close
      assert_true(File.exist?(@path))
      assert_equal('success', File.read(@path))
    end
  end
end
