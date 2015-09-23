require 'csv'
require_relative '../../lib/article'
require_relative '../../lib/articles'
require_relative './generate_doi'
require_relative './author_helper'
require_relative './journal_helper'

module ArticleHelper
  def write_to(file, *articles)
    File.delete(file) if File.exists?(file)
    CSV.open(file, "w") do |csv|
      csv << ["DOI", "Title", "Author", "Journal", "ISSN"]
      articles.each do |article|
        csv << [
          article.doi,
          article.title,
          article.author.join(", "),
          article.journal_published_in.title,
          article.journal_published_in.issn
        ]
      end
    end
  end

  def some_articles *article_data
    Articles.new(
        article_data.collect { |doi, journal, author|
          an_article.with_doi(doi).authored_by(author).published_in(journal)
        }.collect{|article| article.build}
    )
  end

  def an_article
    Builder.new
  end

  class Builder
    include GenerateDOI, AuthorHelper, JournalHelper
    def initialize
      @doi = a_doi
      @authors = [an_author.of_publications(@doi)]
      @journal = a_journal
    end

    def with_doi doi
      @doi = doi

      self
    end

    def authored_by *author_builders
      @authors = author_builders

      self
    end

    def published_in journal_builder
      @journal = journal_builder

      self
    end

    def build
      Article.new(
          {
              doi: @doi,
              title: "::Title::",
              author: @authors.
                  collect{|author| author.build}.
                  collect{|author| author.name},
              journal: @journal.build
          })
    end
  end
end
