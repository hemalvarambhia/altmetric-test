require_relative './file_not_found'
require_relative './article'
require_relative './journals'
require_relative './authors'
# Here we model the concept of a collection of articles
class Articles
  include Enumerable
  extend Forwardable
  def_delegators :@articles, :[], :empty?, :size, :<<

  def initialize(articles = [])
    @articles = articles
  end

  def self.load_from(file_name, journals, authors)
    fail FileNotFound, file_name unless File.exist?(file_name)

    complete_rows = CSV.read(file_name, headers: true).select do |row|
      accurate_information?(row, journals, authors)
    end

    articles = 
      complete_rows.map do |row|
        doi = DOI.new(row['DOI'])
        journal = journals.find_journal_with(ISSN.new(row['ISSN']))
        article_authors = authors.author_of(doi)
          Article.new(
            doi: doi,
            title: row['Title'],
            author: article_authors,
            journal: journal
          )
      end

    Articles.new(articles)
  end

  def each(&block)
    @articles.each(&block)
  end

  private

  def self.accurate_information?(row, journals, authors)
    doi = DOI.new(row['DOI'])
    required_issn = ISSN.new(row['ISSN'])
    journals.journal_with?(required_issn) and authors.author_of(doi).any?
  end
end
