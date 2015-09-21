require 'spec_helper'
require_relative '../lib/file_not_found'
require_relative '../lib/authors'
require_relative '../lib/doi'

describe "Loading authors from a JSON file" do
  context "when the file does not exist" do
    it "raises an error" do
      expect(
          lambda {Authors.load_from("non_existent.json")}
      ).to raise_error(FileNotFound)
    end
  end

  context "when the file has an empty JSON array" do
    it "yields no authors" do
      authors = Authors.load_from(
          File.join(fixtures_dir, "no_authors.json")
      )

      expect(authors).to be_empty
    end
  end

  context "when the file consists of 1 author" do
    context "when that author has no publications" do
      before :each do
      	authors = Array.new(1){
            an_author.of_publications(*[]).build }
        @authors_file = File.join(fixtures_dir, "authors.json")
        write_authors_to @authors_file, *authors
      end

      it "yields no authors" do
        authors = Authors.load_from(@authors_file)

        expect(authors).to be_empty
      end
    end

    context "when that author has 1 or more publications" do
      before :each do
        @expected_authors = Array.new(1){ an_author.build }
        @authors_file = File.join(fixtures_dir, "authors.json")
        write_authors_to @authors_file, *@expected_authors
      end

      it "yields the author" do
        authors = Authors.load_from(@authors_file)

        expect(authors.all).to(eq(@expected_authors))
      end
    end
  end

  context "when the file consists of 2 authors" do
    before :each do
      @expected_authors = Array.new(2){ an_author.build }
      @authors_file = File.join(fixtures_dir, "authors.json")
      write_authors_to @authors_file, *@expected_authors
    end

    context "when the authors have 1 or more publications" do
      it "yields both authors" do
        authors = Authors.load_from(@authors_file)

        expect(authors.all).to(eq(@expected_authors))
      end
    end
  end

  context "when the file consists of 4 authors" do
    before :each do
      @expected_authors = Array.new(4){ an_author.build }
      @authors_file = File.join(fixtures_dir, "authors.json")
      write_authors_to @authors_file, *@expected_authors
    end

    context "when the authors have 1 or more publications" do
      it "yields every author" do
        authors = Authors.load_from(@authors_file)

        expect(authors.all).to(eq(@expected_authors))
      end
    end
  end
end
