require_relative '../../lib/journal'
require_relative './generate_issn'
module JournalHelper
  include GenerateISSN

  def a_journal
    Builder.new(an_issn, "::Academic Journal::")
  end

  class Builder
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
end
