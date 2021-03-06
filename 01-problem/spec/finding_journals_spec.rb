require 'spec_helper'
require_relative '../lib/journals'

describe "Finding journals by ISSN" do
  context "when the article is found" do
    it "is returned" do
      issn_to_find = ISSN.new("0032-1478")  
      journals = some_journals(
          a_journal,
          a_journal.with_issn(issn_to_find),
          a_journal
      )

      journal = journals.find_journal_for(issn_to_find)

      expect(journal).to have_issn(issn_to_find)
    end

    context "finding a journal for a different ISSN" do
      it "is returned" do
        issn_to_find = ISSN.new("0378-5955")
        journals = some_journals(
            a_journal,
            a_journal.with_issn(issn_to_find),
            a_journal
        )
        
        journal = journals.find_journal_for(issn_to_find)

        expect(journal).to(have_issn(issn_to_find))
      end
    end
  end

  context "when the journal cannot be found" do
    it "returns no journal" do
      journals = some_journals(a_journal, a_journal, a_journal)

      non_existent = journals.find_journal_for(ISSN.new("0378-5955"))

      expect(non_existent).to be_nil
    end
  end
end
