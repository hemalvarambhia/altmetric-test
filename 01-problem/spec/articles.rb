class Articles
  def initialize(articles)
    @articles = articles || []
  end

  def self.load_from(
      file_name, journals, articles)

    raise Exception.new(
            "'#{file_name}' does not exist")
  end

  def all
    @articles
  end

  def empty?
    @articles.empty?
  end
end
