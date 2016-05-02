module Tumugi
  class FileSystemError < StandardError
  end

  class FileAlreadyExistError < FileSystemError
  end

  class MissingParentDirectoryError < FileSystemError
  end

  class NotADirectoryError < FileSystemError
  end
end
