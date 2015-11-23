require_relative '../lib/json_renderer'
# Helper class that converts the articles to the expected
# parsed format
module JSONRenderingHelper
  def expected_format(articles)
    articles.map do |article|
      {
        'doi' => article.doi.to_s,
        'title' => article.title,
        'author' => article.author.map { |author| author.name }.join(','),
        'journal' => article.journal_published_in.title,
        'issn' => article.journal_published_in.issn.to_s
      }
    end
  end

  def render(all_articles)
    JSON.parse(JSONRenderer.new.render(all_articles))
  end

  def author_of_article(index, rendered_articles)
    rendered_articles[index]['author']
  end
end
