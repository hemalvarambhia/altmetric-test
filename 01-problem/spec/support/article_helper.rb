require 'csv'
require_relative '../../lib/article'
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
    article_data.collect { |doi, journal, author|
      an_article.with_doi(doi).authored_by(author).published_in(journal)
    }.collect{|article| article.build}
  end

  def an_article
    Builder.new
  end

  class Builder
    include GenerateDOI, AuthorHelper, JournalHelper
    def initialize
      @attributes = {
        doi: a_doi,
        title: "::An Article::",
        author: an_author,
        journal: a_journal
      }
    end

    def with_doi doi
      @attributes = @attributes.merge({doi: doi})

      self
    end

    def authored_by *author_builders
      authors_of_article = author_builders.collect{|builder|
        builder.build
      }
      @attributes = @attributes.merge(
        {
          author: authors_of_article.
            collect{|author| author.name}
        }
      )

      self
    end

    def published_in journal_builder
      @attributes = @attributes.merge({journal: journal_builder.build})

      self
    end

    def build
      Article.new @attributes
    end
  end
end
