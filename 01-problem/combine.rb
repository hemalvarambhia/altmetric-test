require_relative './lib/journals'
require_relative './lib/authors'
require_relative './lib/articles'
require_relative './lib/rendering_factory'

require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: combine.rb [options]"

  opts.on("-f", "--format FORMAT", String, "Render articles to a particular format") do |format|
    options[:format] = format
  end
end.parse!
format = options[:format]
journal_csv, articles_csv, authors_json = [ARGV[0], ARGV[1], ARGV[2]] 

journals = Journals.from_file(journal_csv)
authors = Authors.from_file(authors_json)
articles = Articles.from_file(articles_csv, journals, authors)
rendering_factory = RenderingFactory.new
renderer = rendering_factory.renderer_for format
puts renderer.render articles
