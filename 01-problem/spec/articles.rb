class Articles
  def initialize(articles)
    @articles = articles || []
  end

  def self.load_from(
      file_name, journals, articles)
    if not File.exists?(file_name)
      raise Exception.new(
            "'#{file_name}' does not exist")
    end

    Articles.new([])
  end

  def all
    @articles
  end

  def empty?
    @articles.empty?
  end
end
