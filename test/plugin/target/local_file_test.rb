require_relative '../../test_helper'
require 'tumugi/plugin/target/local_file'

class Tumugi::Plugin::LocalFileTargetTest < Test::Unit::TestCase
  setup do
    @path = "tmp/local_file_target_test_file_#{SecureRandom.uuid}"
  end

  test 'plugin' do
    assert_equal(Tumugi::Plugin::LocalFileTarget, Tumugi::Plugin.lookup_target('local_file'))
  end

  sub_test_case '#exist?' do
    test 'returns true when file exists' do
      target = Tumugi::Plugin::LocalFileTarget.new(@path)
      File.write(@path, 'done')
      assert_true(target.exist?)
    end

    test 'returns false when file not exists' do
      target = Tumugi::Plugin::LocalFileTarget.new('not_exist_file')
      assert_false(target.exist?)
    end
  end

  test '#fs' do
    target = Tumugi::Plugin::LocalFileTarget.new(@path)
    assert_true(target.fs.is_a?(Tumugi::Plugin::LocalFileSystem))
  end

  sub_test_case '#open' do
    setup do
      @target = Tumugi::Plugin::LocalFileTarget.new(@path)
    end

    sub_test_case 'read' do
      test 'with block' do
        File.write(@path, 'done')
        result = ''
        @target.open('r') do |f|
          result = f.read
        end
        assert_equal('done', result)
      end
    end

    sub_test_case 'write' do
      test 'with block' do
        @target.open('w') do |f|
          10000.times.each do
            f.puts 'done'
          end
        end
        assert_true(@target.exist?)
        assert_equal("done\n"*10000, File.read(@target.path))
      end

      test 'without block' do
        f = @target.open('w')
        f.print 'done'
        f.flush
        f.close
        assert_equal('done', File.read(@target.path))
      end
    end
  end
end
