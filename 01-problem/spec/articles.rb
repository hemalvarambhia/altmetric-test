class Articles
  def initialize(articles)
    @articles = articles || []
  end

  def self.load_from(
      file_name, journals, articles)
     Articles.new([])
  end

  def all
    @articles
  end
end