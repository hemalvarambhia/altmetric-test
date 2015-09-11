class Articles
  def initialize(articles)
    @articles = articles || []
  end

  def all
    @articles
  end
end