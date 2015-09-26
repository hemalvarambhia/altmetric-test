require 'json'
# Converts articles to JSON format
class JSONRenderer
  def render(articles)
    articles.map { |article| as_hash(article) }.to_json
  end

  private

  def as_hash(article)
    {
      'doi' => article.doi,
      'title' => article.title,
      'author' => article.author.join(', '),
      'journal' => article.journal_published_in.title,
      'issn' => article.journal_published_in.issn
    }
  end
end
