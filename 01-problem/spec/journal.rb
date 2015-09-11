class Journal
  attr_reader :title
  def initialize(issn, title)
    @issn = issn
    @title = title
  end

  def issn
    @issn.to_s
  end
end