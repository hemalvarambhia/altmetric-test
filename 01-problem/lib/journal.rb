class Journal
  attr_reader :title, :issn
  def initialize(issn, title)
    @issn = issn
    @title = title
  end

  def ==(other)
    @issn == other.issn
  end
end
