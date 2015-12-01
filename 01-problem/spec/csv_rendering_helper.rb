require_relative '../lib/csv_renderer'
# Converts articles to the expected (CSV) format
module CSVRenderingHelper
  def expected_format(articles)
    articles.map do |article|
      [
        article.doi.to_s,
        article.title,
        article.authors.map{ |author| author.name }.join(', '),
        article.journal_published_in.title,
        article.journal_published_in.issn.to_s
      ]
    end
  end

  def without_header(csv_rows)
    csv_rows.drop(1)
  end

  def render(all_articles)
    without_header(
        CSV.parse(Rendering::AsCSV.new.render(all_articles)))
  end

  def author_of_article(index, rendered_articles)
    rendered_articles[index][2]
  end
end
