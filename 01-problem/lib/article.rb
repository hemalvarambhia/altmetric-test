class Article
  attr_reader :title, :author, :doi, :journal
  def initialize(hash)
    @doi = hash[:doi]
    @title = hash[:title]
    @author = hash[:author]
    @journal = hash[:journal]
  end

  def journal_published_in
    journal
  end

  def ==(other)
    @doi == other.doi && @journal == other.journal
  end
end
