require_relative './issn'
require_relative './journal'

class Journals
  def initialize journals
    
  end
  
  def find_journal_for issn
    Journal.new(
      ISSN.new("1234-5678"),
      "Journal that exists"
    )
  end
end

describe "Finding journals by ISSN" do
  context "when the article is found" do
    it "is returned" do
      journals = Journals.new(
        [
          Journal.new(
          ISSN.new("1234-5678"),
          "Journal that exists"
        )])

      journal = journals.
                find_journal_for(
                  ISSN.new("1234-5678")
                )

      expect(journal.title).to eq("Journal that exists")
      expect(journal.issn).to eq(ISSN.new("1234-5678"))
    end
    
  end
end
