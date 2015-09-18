class JournalBuilder
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
