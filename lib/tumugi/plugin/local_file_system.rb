require 'fileutils'
require 'tumugi/file_system'
require 'tumugi/file_system_error'

module Tumugi
  module Plugin
    class LocalFileSystem
      def exist?(path)
        File.exist?(path)
      end

      def remove(path, recursive: true)
        if recursive && directory?(path)
          FileUtils.rm_r(path)
        else
          FileUtils.remove_file(path)
        end
      end

      def mkdir(path, parents: true, raise_if_exist: false)
        if File.exist?(path)
          if raise_if_exist
            raise FileAlreadyExistError
          elsif !directory?(path)
            raise NotADirectoryError
          else
            return
          end
        end

        if parents
          FileUtils.mkdir_p(path)
        else
          if File.exist?(File.expand_path("..", path))
            FileUtils.mkdir(path)
          else
            raise MissingParentDirectoryError
          end
        end
      end

      def directory?(path)
        File.directory?(path)
      end

      def entries(path)
        if directory?(path)
          Dir.glob(File.join(path, '*'))
        else
          raise NotADirectoryError
        end
      end

      def move(src, dest, raise_if_exist: false)
        if File.exist?(dest) && raise_if_exist
          raise FileAlreadyExistError
        end
        FileUtils.mv(src, dest, force: true)
      end
    end
  end
end
