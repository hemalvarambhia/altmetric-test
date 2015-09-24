require 'spec_helper'
require_relative '../lib/doi'
require_relative '../lib/author'
require_relative '../lib/authors'

describe "Finding authors by their publications" do
  include GenerateDOI
  context "when there is 1 author of the publication" do
    it "yields the author" do
      publication = a_doi
      authors = authors(
        an_author,
        an_author,
        an_author.who_published(publication)
      )
      
      authors = authors.author_of publication

      expect(authors).to have_published publication
    end
  end

  context "when there are several authors of the publication" do
    it "yields them all" do
      publication = a_doi
      authors = authors(
        an_author.who_published(a_doi, publication),
        an_author.who_published(publication),
        an_author.who_published(a_doi, publication, a_doi),
        an_author
      )

      authors = authors.author_of publication

      expect(authors.size).to be > 1
      expect(authors).to have_published publication
    end
  end

  context "when there are no authors of the publication" do
    it "yields none" do
      publication = a_doi
      authors = authors(an_author, an_author, an_author)

      author = authors.author_of publication

      expect(author).to be_empty
    end
  end

  def authors(*builders)
    Authors.new builders.collect{|builder| builder.build}
  end

  RSpec::Matchers.define :have_published do |publication|
    match do |authors|
      authors.size > 0 &&
          authors.all?{|author| author.publications.include?(publication)}
    end
  end
end
