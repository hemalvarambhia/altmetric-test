class Author
  attr_reader :name, :publications
  def initialize(name, publications)
    @name = name
    @publications = publications
  end

  def has_publications?
    @publications.any?
  end

  def published?(doi)
    @publications.include? doi
  end

  def == other
    @publications == other.publications && @name == other.name
  end
end
