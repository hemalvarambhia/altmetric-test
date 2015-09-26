# A better intent-revealing exception when a file is not found
class FileNotFound < Exception
  def initialize(file_name)
    super "File '#{file_name}' not found"
  end
end
