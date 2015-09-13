require_relative './lib/journals'
require_relative './lib/authors'
require_relative './lib/articles'
require_relative './lib/json_renderer'
require_relative './lib/csv_renderer'

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

journals = Journals.load_from(journal_csv)
authors = Authors.load_from(authors_json)
articles = Articles.load_from(articles_csv, journals, authors)

renderer = case format
         when "json"
           JSONRenderer.new
         when "csv"
           CSVRenderer.new
         end

p renderer.render articles