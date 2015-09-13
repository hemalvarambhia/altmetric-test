class Author
  attr_reader :name, :publications
  def initialize(name, publications)
    @name = name
    @publications = publications
  end
end
