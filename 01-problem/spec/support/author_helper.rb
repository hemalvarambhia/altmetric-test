require_relative '../../lib/author'
require_relative './generate_doi'
module AuthorHelper
  def an_author
    Builder.new
  end

  class Builder
    include GenerateDOI
    def initialize
      @name = "::Author::"
      @publications = Array.new(3){|index| a_doi}
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
