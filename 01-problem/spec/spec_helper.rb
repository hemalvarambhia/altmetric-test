require_relative './fixtures_helper'
require_relative './support/journal_helper'
require_relative './support/author_helper'
require_relative './support/article_helper'
RSpec.configure do |config|
  config.include GenerateDOI
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

