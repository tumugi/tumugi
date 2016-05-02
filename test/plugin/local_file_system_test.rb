require_relative '../test_helper'
require 'tumugi/plugin/local_file_system'
require 'fileutils'

class Tumugi::Plugin::LocalFileSystemTest < Test::Unit::TestCase
  setup do
    @fs = Tumugi::Plugin::LocalFileSystem.new
    @dir_name = "#{SecureRandom.uuid}"
    @file_name = "local_file_system_test_file"
    @dir = "tmp/#{@dir_name}"
    @file = "#{@dir}/#{@file_name}"
    FileUtils.mkdir_p(@dir)
    File.write(@file, 'done')
  end

  teardown do
    FileUtils.rm_rf(@dir)
  end

  sub_test_case '#exist?' do
    test 'true' do
      assert_true(@fs.exist?(@file))
    end

    test 'false' do
      assert_false(@fs.exist?('not_exist_file'))
    end
  end

  sub_test_case '#remove' do
    test 'non recursive' do
      @fs.remove(@file, recursive: false)
      assert_false(File.exist?(@file))
    end

    sub_test_case 'recursive' do
      test 'directory' do
        @fs.remove(@dir, recursive: true)
        assert_false(File.exist?(@file))
      end

      test 'file' do
        @fs.remove(@file, recursive: true)
        assert_false(File.exist?(@file))
      end
    end
  end

  sub_test_case '#mkdir' do
    sub_test_case 'when path exist' do
      test 'raise FileAlreadyExistError if raise_if_exist flag is true' do
        assert_raise(Tumugi::FileAlreadyExistError) do
          @fs.mkdir(@dir, raise_if_exist: true)
        end
      end

      test 'raise NotADirectoryError if path raise_if_exist is false and path is not a directory' do
        assert_raise(Tumugi::NotADirectoryError) do
          @fs.mkdir(@file, raise_if_exist: false)
        end
      end
    end

    test 'create parent directory when parent flag is true' do
      dir = File.join(@dir, 'parent/child')
      @fs.mkdir(dir, parents: true)
      assert_true(File.exist?(dir))
      assert_true(File.directory?(dir))
    end

    sub_test_case 'when parent flag is false' do
      test 'create directory if parent directory exists' do
        dir = File.join(@dir, 'child')
        @fs.mkdir(dir, parents: false)
        assert_true(File.exist?(dir))
        assert_true(File.directory?(dir))
      end

      test 'raise error if parent directory does not exist' do
        assert_raise(Tumugi::MissingParentDirectoryError) do
          dir = File.join(@dir, 'parent/child')
          @fs.mkdir(dir, parents: false)
        end
      end
    end
  end

  sub_test_case '#directory?' do
    test 'true' do
      assert_true(@fs.directory?('tmp'))
    end

    test 'false' do
      assert_false(@fs.directory?(@file))
    end
  end

  sub_test_case '#entries' do
    test 'raise error when path is not a directory' do
      assert_raise(Tumugi::NotADirectoryError) do
        @fs.entries(@file)
      end
    end

    test 'returns list of files in a directory' do
      l = @fs.entries(@dir)
      assert_equal(1, l.size)
      assert_equal(@file, l.first)
    end
  end

  sub_test_case '#move' do
    sub_test_case 'when destination file exist' do
      test 'raise FileAlreadyExistError if raise_if_exist flag is true' do
        assert_raise(Tumugi::FileAlreadyExistError) do
          dest_dir = "tmp/#{SecureRandom.uuid}"
          FileUtils.mkdir_p(dest_dir)
          File.write("#{dest_dir}/#{@file_name}", 'test')
          @fs.move(@file, "#{dest_dir}/#{@file_name}", raise_if_exist: true)
        end
      end

      test 'overwrite if raise_if_exist flag is false' do
        dest_dir = "tmp/#{SecureRandom.uuid}"
        FileUtils.mkdir_p(dest_dir)
        File.write("#{dest_dir}/#{@file_name}", 'test')
        @fs.move(@file, "#{dest_dir}/#{@file_name}", raise_if_exist: false)
        assert_equal('done', File.read("#{dest_dir}/#{@file_name}"))
      end
    end

    test 'creat new file when destination file is not exist' do
      dest_dir = "tmp/#{SecureRandom.uuid}"
      FileUtils.mkdir_p(dest_dir)
      @fs.move(@file, "#{dest_dir}/#{@file_name}", raise_if_exist: false)
      assert_equal('done', File.read("#{dest_dir}/#{@file_name}"))
    end
  end
end
