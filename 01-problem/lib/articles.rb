require_relative '../lib/file_not_found'
require_relative './article'
class Articles
  include Enumerable
  extend Forwardable
  def_delegator :@articles, :[]
  def_delegator :@articles, :empty?
  def_delegator :@articles, :size


  def initialize(articles)
    @articles = articles || []
  end

  def self.load_from(file_name, journals, authors)
    if not File.exists?(file_name)
      raise FileNotFound.new(file_name)
    end
    articles =
        CSV.read(file_name, {headers: true}).select do |csv|
          doi = DOI.new(csv["DOI"])
          journals.any?{ |journal| journal.issn == ISSN.new(csv["ISSN"]) } and
              authors.any?{|author| author.published?(doi) }
        end.collect do |csv|
          doi = DOI.new(csv["DOI"])
          journal = journals.find_journal_with(ISSN.new(csv["ISSN"]))
          article_authors = authors.author_of(doi).collect{|author| author.name }
          Article.new(
              doi: doi,
              title: csv["Title"],
              author: article_authors,
              journal: journal
          )
        end

    return Articles.new(articles)
  end

  def each &block
    @articles.each &block
  end
end
