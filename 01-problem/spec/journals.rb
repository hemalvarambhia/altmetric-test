class Journals
  def initialize journals
    @journals = journals || []
  end
  
  def find_journal_for required_issn
    @journals.detect{|journal|
      journal.issn == required_issn
    }
  end
end
