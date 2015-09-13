require_relative '../lib/author'
require_relative './doi'

describe "Loading authors from a JSON file" do
  context "when the file does not exist" do
    it "raises an error"
  end

  context "when the file is empty" do
    it "yields no authors"
  end

  context "when the file has an empty JSON array" do
    it "yields no authors"
  end

  context "when the file consists of one author" do
    context "when that author has no publications" do
      it "yields no authors"
    end

    context "when that authors has 1 or more publications" do
      it "yields the author"
    end
  end

  context "when the file consists of two authors" do
    context "when the author has 1 or more publications" do
      it "yields both authors"
    end
  end

  context "when the file consists of many authors" do
    context "when the authors has many publications" do
      it "yields every author"
    end
  end
end
