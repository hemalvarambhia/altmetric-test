require_relative './fixtures_helper'
require_relative './support/journal_helper'
require_relative './support/author_helper'
require_relative './support/article_helper'
RSpec.configure do |config|
  config.include FixturesHelper
  config.include JournalHelper
  config.include AuthorHelper
  config.include ArticleHelper
end

RSpec::Matchers.define :have_issn do |expected_issn|
  match do |journal|
    journal.issn == expected_issn
  end
end

RSpec::Matchers.define :have_published do |publication|
  match do |authors|
    authors.size > 0 &&
      authors.all?{|author| author.publications.include?(publication)}
  end
end

RSpec::Matchers.define :have_loaded do |expected_articles|
  match do |actual_articles|
    outcome = true
    actual_articles.each_index do |index|
      expected = expected_articles[index]
      actual = actual_articles[index]
      outcome = outcome && are_equal?(actual, expected)
    end

    outcome && actual_articles.size == expected_articles.size
  end

  def are_equal?(expected, actual)
    actual.doi == expected.doi &&
      actual.title == expected.title &&
      actual.author == expected.author &&
      actual.journal_published_in.issn == expected.journal_published_in.issn &&
      actual.journal_published_in.title == expected.journal_published_in.title
  end
end
