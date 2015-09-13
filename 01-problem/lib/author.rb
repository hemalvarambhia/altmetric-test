class Author
  attr_reader :name, :publications
  def initialize(name, publications)
    @name = name
    @publications = publications
  end

  def has_publications?
    @publications.any?
  end

  def == other
    @publications == other.publications
  end
end
