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


