require 'json'
# Converts articles to JSON format
class JSONRenderer
  def render(articles)
    JSON.pretty_generate(articles.map { |article| as_hash(article) })
  end

  private

  def as_hash(article)
    {
      'doi' => article.doi,
      'title' => article.title,
      'author' => article.authors.map { |author| author.name }.join(', '),
      'journal' => article.journal_published_in.title,
      'issn' => article.journal_published_in.issn
    }
  end
end
