require_relative '../../lib/author'
require_relative './generate_doi'
# A Helper module for building authors for tests
module AuthorHelper
  def an_author
    Builder.new
  end

  def co_authors_of(publication)
     Array.new(4) do 
       an_author.who_published(publication) 
     end.map { |co_author| co_author.build }
  end

  # Builder class for building Author in a way
  # that emphasises what is important in a test
  class Builder
    include GenerateDOI
    def initialize
      @name = '::Author::'
      @publications = Array.new(3) { a_doi }
    end

    def who_published(*dois)
      @publications += dois.to_a

      self
    end

    def with_no_publications
      @publications = []

      self
    end

    def build
      Author.new(@name, @publications)
    end
  end
end
