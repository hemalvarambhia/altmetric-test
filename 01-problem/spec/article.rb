class Article
  attr_reader :title, :author
  def initialize(hash)
    @doi = hash[:doi]
    @title = hash[:title]
    @author = hash[:author]
    @journal = hash[:journal]
  end

  def journal_published_in
    @journal
  end

  def doi
    @doi.to_s
  end
end