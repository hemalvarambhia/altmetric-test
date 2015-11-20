require_relative '../lib/file_not_found'
require_relative './article'
# Here we model the concept of a collection of articles
class Articles
  include Enumerable
  extend Forwardable
  def_delegators :@articles, :[], :empty?, :size, :<<

  def initialize(articles = [], journals = [], authors = [])
    @articles = articles || []
    @journals = journals
    @authors = authors
  end

  def load_from(file_name)
    fail FileNotFound, file_name unless File.exist?(file_name)

    complete_rows = CSV.read(file_name, headers: true).select do |row|
      accurate_information?(row)
    end

    @articles = 
      complete_rows.map do |row|
        doi = DOI.new(row['DOI'])
        journal = @journals.find_journal_with(ISSN.new(row['ISSN']))
        article_authors = @authors.author_of(doi).map { |author| author.name } 
          Article.new(
            doi: doi,
            title: row['Title'],
            author: article_authors,
            journal: journal
          )
      end
  end

  def each(&block)
    @articles.each(&block)
  end

  private

  def accurate_information?(row)
    doi = DOI.new(row['DOI'])
    required_issn = ISSN.new(row['ISSN'])
    @journals.journal_with?(required_issn) and @authors.author_of(doi).any?
  end
end
