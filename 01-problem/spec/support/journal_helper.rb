require_relative '../../lib/journal'
require_relative './generate_issn'
# A Helper module for building journals
module JournalHelper
  include GenerateISSN

  def a_journal
    Builder.new(an_issn, '::Academic Journal::')
  end
  # Builder class to construct authors in a way that
  # emphasises what is important in the test
  class Builder
    def initialize(issn, name_of_journal)
      @issn = issn
      @name = name_of_journal
    end

    def with_issn(issn)
      @issn = issn

      self
    end

    def build
      Journal.new(@issn, @name)
    end
  end
end
