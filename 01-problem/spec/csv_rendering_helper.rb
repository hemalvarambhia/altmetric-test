require_relative '../lib/csv_renderer'
module CSVRenderingHelper
  def expected_format(articles)
    articles.all.collect do |article|
      [
          article.doi.to_s,
          article.title,
          article.author.join(", "),
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
        CSV.parse(CSVRenderer.new.render(all_articles)))
  end
end