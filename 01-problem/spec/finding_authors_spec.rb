require_relative '../lib/doi'
require_relative '../lib/author'
require_relative '../lib/authors'

describe "Finding authors by their publications" do
  context "when there is 1 author of the publication" do
    it "yields the author" do
      authors = Authors.new(
        [
          Author.new(
          "Author Name", [DOI.new("10.1234/altmetric101")]),
        ]
      )
      author = authors.author_of DOI.new("10.1234/altmetric101")

      expect(author).to eq(["Author Name"])
    end
  end

  context "when there is another author for a different publication" do
    it "yields that author"
  end

  context "when there are several authors of the publication" do
    it "yields them all"
  end

  context "when there are no authors of the publication" do
    it "yields none"
  end
end
