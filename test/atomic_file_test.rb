require_relative './test_helper'
require 'fileutils'
require 'tempfile'
require 'tumugi/atomic_file'

class Tumugi::AtomicFileTest < Test::Unit::TestCase
  class AtomicTestFile < Tumugi::AtomicFile
    def move_to_final_destination(tmp_file)
      FileUtils.move(tmp_file.path, path)
    end
  end

  setup do
    @path = "tmp/atomic_test_file_#{SecureRandom.uuid}"
    @file = AtomicTestFile.new(@path)
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
