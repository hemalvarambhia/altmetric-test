class Articles
  def initialize(articles)
    @articles = articles || []
  end

  def self.load_from(
      file_name, journals, authors)
    if not File.exists?(file_name)
      raise Exception.new(
            "'#{file_name}' does not exist")
    end
    articles = []
    CSV.foreach(file_name, {headers: true}) do |csv|
      doi = DOI.new(csv["DOI"])
      journal = journals.find_journal_for(ISSN.new(csv["ISSN"]))
      if journal
        articles << Article.new(
        doi: doi,
        title: csv["Title"],
        author: authors.author_of(doi),
        journal: journals.
          find_journal_for(
            ISSN.new(csv["ISSN"])))
      end
    end
    Articles.new(
      articles
    )
  end

  def all
    @articles
  end

  def first
    @articles.first
  end

  def empty?
    @articles.empty?
  end
end
