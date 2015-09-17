class JournalBuilder
  def self.a_journal(issn = ISSN.new("0387-5955"), name = "Physical Review A")
    JournalBuilder.new(issn, name)
  end

  def initialize(issn, name_of_journal)
    @issn = issn
    @name = name_of_journal 
  end

  def with_issn issn
    @issn = issn

    self
  end

  def build
    Journal.new(@issn, @name)
  end
end
