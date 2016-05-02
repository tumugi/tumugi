require 'tumugi'
require 'tumugi/file_system_error'

module Tumugi
  # This class defines interfaces of file system
  # such as local file, Amazon S3, Google Cloud Storage
  class FileSystem
    def exist?(path)
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end

    def remove(path, recursive: true)
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end

    def mkdir(path, parents: true, raise_if_exist: false)
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end

    def directory?(path)
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end

    def entries(path)
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end

    def move(src, dest, raise_if_exist: false)
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end

    def rename(path, dest)
      Tumugi.logger.warn "File system #{self.class.name} client doesn't support atomic move."
      raise FileAlreadyExistError if exist?(dest)
      move(path, dest)
    end
  end
end
