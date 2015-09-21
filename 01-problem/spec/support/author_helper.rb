require_relative '../../lib/author'
require_relative '../../lib/authors'
require_relative './generate_doi'
module AuthorHelper
  def write_to authors_file, *authors
    File.open(authors_file, "w") do |file|
      file.puts <<
          authors.collect{|author|
            [
                {
                    "name" => author.name,
                    "articles" => author.publications
                }
            ]
          }.to_json

    end
  end

  def some_authors(*builders)
    Authors.new builders.collect{|builder| builder.build}
  end

  def an_author
    Builder.new
  end

  class Builder
    include GenerateDOI
    def initialize
      @name = "::Author::"
      @publications = Array.new(3){|index| a_doi}
    end

    def of_publications(*dois)
      @publications = dois.to_a

      self
    end

    def build
      Author.new(@name, @publications)
    end
  end
end
