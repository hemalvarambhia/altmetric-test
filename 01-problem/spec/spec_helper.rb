require_relative './fixtures_helper'
require_relative './support/journal_helper'
require_relative './support/author_helper'
RSpec.configure do |config|
  config.include FixturesHelper
  config.include JournalHelper
  config.include AuthorHelper
end

RSpec::Matchers.define :have_issn do |expected_issn|
  match do |journal|
    journal.issn == expected_issn
  end
end
