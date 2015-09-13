class FileNotFound < Exception
  def initialize file_name
    super "File '#{file_name}' not found"
  end
end
