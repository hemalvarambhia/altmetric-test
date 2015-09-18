require_relative './fixtures_helper'
require_relative './support/journal_helper'

RSpec.configure do |config|
  config.include FixturesHelper
  config.include JournalHelper
end

RSpec::Matchers.define :have_issn do |expected_issn|
  match do |journal|
    journal.issn == expected_issn
  end
end
