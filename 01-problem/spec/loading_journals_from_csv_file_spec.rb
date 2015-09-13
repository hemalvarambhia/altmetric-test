require_relative './journals'
require_relative './file_not_found'

def fixtures_dir
  File.join(
    File.dirname(__FILE__),
    "fixtures")
end

describe "Loading journals from csv files" do
  context "when the file does not exist" do
    it "raises an error" do
      expect(lambda {
               Journals.load_from("non_existent.csv")
             }).to raise_error(FileNotFound)
    end
  end

  context "when the file has no journals (just headers)" do
    it "loads no journals" do
      journals = Journals.load_from(
        File.join(fixtures_dir, "no_journals.csv")
      )

      expect(journals).to be_empty
    end
  end

  context "when the file has 1 journal" do
    it "loads that article"
  end

  context "when the file has 2 journals" do
    it "loads both journals"
  end

  context "when the file has many journals" do
    it "loads every journal"
  end
end
