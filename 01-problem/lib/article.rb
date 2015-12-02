# Models the concept of an academic article published in a journal
module AcademicResearch
  class Article
    attr_reader :title, :authors, :doi, :journal
    def initialize(hash)
      @doi = hash[:doi]
      @title = hash[:title]
      @authors = hash[:author]
      @journal = hash[:journal]
    end

    def journal_published_in
      journal
    end

    def ==(other)
      @doi == other.doi && @journal == other.journal
    end
  end
end
