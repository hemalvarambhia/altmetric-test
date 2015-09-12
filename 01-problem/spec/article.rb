class Article
  attr_reader :title, :author, :doi
  def initialize(hash)
    @doi = hash[:doi]
    @title = hash[:title]
    @author = hash[:author]
    @journal = hash[:journal]
  end

  def journal_published_in
    @journal
  end
end
