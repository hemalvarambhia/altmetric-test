class Journals
  def initialize journals
    @journals = journals || []
  end
  
  def find_journal_for required_issn
    @journals.detect{|journal|
      journal.issn == required_issn
    }
  end

  def empty?
    @journals.empty?
  end
  
  def self.load_from(file_name)
    if not File.exists?(file_name)
      raise FileNotFound.new("'#{file_name}' not found")
    end

    Journals.new([])
  end
end
