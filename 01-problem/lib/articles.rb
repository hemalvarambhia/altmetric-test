require_relative '../lib/file_not_found'
require_relative './article'
class Articles
  include Enumerable
  extend Forwardable
  def_delegator :@articles, :[]
  def_delegator :@articles, :empty?
  def_delegator :@articles, :size


  def initialize(articles = [])
    @articles = articles || []
  end

  def self.load_from(file_name, journals, authors)
    unless File.exists?(file_name)
      raise FileNotFound.new(file_name)
    end

    complete_rows = CSV.read(file_name, {headers: true}).select do |row|
      has_complete_information?(row, journals, authors)
    end

    articles = complete_rows.collect do |row|
      doi = DOI.new(row["DOI"])
      journal = journals.find_journal_with(ISSN.new(row["ISSN"]))
      article_authors = authors.author_of(doi).collect{|author| author.name }
      Article.new(
          doi: doi,
          title: row["Title"],
          author: article_authors,
          journal: journal
      )
    end

    return Articles.new(articles)
  end

  def each &block
    @articles.each &block
  end

  private

  def self.has_complete_information?(row, journals, authors)
    doi = DOI.new(row["DOI"])
    required_issn = ISSN.new(row["ISSN"])
    journals.has_journal_with?(required_issn) and authors.author_of(doi).any?
  end
end
