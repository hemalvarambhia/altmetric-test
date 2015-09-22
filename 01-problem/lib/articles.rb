require_relative '../lib/file_not_found'
require_relative './article'
class Articles
  include Enumerable

  def initialize(articles)
    @articles = articles || []
  end

  def self.load_from(
      file_name, journals, authors)
    if not File.exists?(file_name)
      raise FileNotFound.new(file_name)
    end
    articles = []
    CSV.foreach(file_name, {headers: true}) do |csv|
      doi = DOI.new(csv["DOI"])
      journal = journals.find_journal_for(ISSN.new(csv["ISSN"]))
      article_authors = authors.author_of(doi)
      if journal and article_authors.any?
        articles << Article.new(
            doi: doi,
            title: csv["Title"],
            author: article_authors.collect{|author| author.name },
            journal: journals.
                find_journal_for(
                    ISSN.new(csv["ISSN"])))
      end
    end

    return Articles.new(articles)
  end

  def all
    @articles
  end

  def each &block
    @articles.each &block
  end

  def empty?
    @articles.empty?
  end
end
