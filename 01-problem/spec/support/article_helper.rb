require_relative '../../lib/article'
require_relative './generate_doi'
require_relative './author_helper'
require_relative './journal_helper'
# Helper Module for creating articles
module ArticleHelper
  def an_article
    Builder.new
  end
  # Builder class to build Article in a way
  # that emphasises what is important in the test
  class Builder
    include GenerateDOI, AuthorHelper, JournalHelper
    def initialize
      @doi = a_doi
      @authors = [an_author.who_published(@doi).build]
      @journal = a_journal.build
    end

    def with_doi(doi)
      @doi = doi

      self
    end

    def authored_by(*author)
      @authors = author

      self
    end

    def published_in(journal)
      @journal = journal

      self
    end

    def build
      AcademicResearch::Article.new(
        doi: @doi,
        title: '::Title::',
        author: @authors,
        journal: @journal
      )
    end
  end
end
