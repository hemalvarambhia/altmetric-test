require 'spec_helper'
require_relative '../lib/file_not_found'
require_relative '../lib/authors'
require_relative '../lib/doi'

describe "Loading authors from a JSON file" do
  before :each do
    @authors_file = File.join(fixtures_dir, "authors.json")
  end

  context "when the file does not exist" do
    it "raises an error" do
      expect(
          lambda {Authors.load_from("non_existent.json")}
      ).to raise_error(FileNotFound)
    end
  end

  context "when the file has no authors" do
    it "yields no authors" do
      write_authors_to @authors_file

      authors = Authors.load_from(@authors_file)

      expect(authors).to be_empty
    end
  end

  context "when an author has no publications" do
    before :each do
      authors = Array.new(1){ an_author.of_publications(*[]).build }
      write_authors_to @authors_file, *authors
    end

    it "yields no authors" do
      authors = Authors.load_from(@authors_file)

      expect(authors).to be_empty
    end
  end

  [1, 2, 4].each do |number_of|
    context "when the file consists of #{number_of} author(s)" do
      context "when the author(s) has/have 1 or more publications" do
        before :each do
          @expected_authors = Array.new(number_of){ an_author.build }
          write_authors_to @authors_file, *@expected_authors
        end

        it "yields every author" do
          authors = Authors.load_from(@authors_file)

          expect(authors.all).to(eq(@expected_authors))
        end
      end
    end
  end
end
