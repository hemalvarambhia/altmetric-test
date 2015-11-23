require_relative './spec_helper'
require_relative '../lib/doi'
require_relative '../lib/issn'
require_relative '../lib/journal'
require_relative '../lib/article'
require_relative '../lib/articles'

shared_examples 'a renderer' do
  describe 'Rendering no articles' do
    it 'contains nothing' do
      no_articles = Articles.new

      rendered_articles = render(no_articles)

      expect(rendered_articles).to be_empty
    end
  end

  describe 'Rendering of 1 article' do
    context 'when the article has one author' do
      before(:each) do
        @all_articles = articles 1
      end

      it 'contains the details of the article' do
        rendered_articles = render(@all_articles)

        expect(rendered_articles).to(eq(expected_format(@all_articles)))
      end
    end

    context 'when the article has multiple authors' do
      before(:each) do
        doi = a_doi
        @multiple_authors = [
          an_author.who_published(doi),
          an_author.who_published(doi),
          an_author.who_published(doi)
        ].map { |author| author.build }
        @all_articles = Articles.new(
          [
            an_article.with_doi(doi)
            .authored_by(*@multiple_authors).build
          ]) 
      end

      it 'renders the authors as a comma-separated string' do
        rendered_articles = render(@all_articles)

        author_names_comma_separated =
          @multiple_authors.map { |author| author.name }.join(', ')
        expect(author_of_article(0, rendered_articles))
          .to(eq(author_names_comma_separated))
      end
    end
  end

  describe 'Rendering two articles' do
    before(:each) do
      @all_articles = articles 2
    end

    it 'contains the details of both articles' do
      rendered_articles = render(@all_articles)

      expect(rendered_articles).to(eq(expected_format(@all_articles)))
    end
  end

  describe 'Rendering many articles' do
    before(:each) do
      @all_articles = articles 3
    end

    it 'contains the details of every article' do
      rendered_articles = render(@all_articles)

      expect(rendered_articles).to(eq(expected_format(@all_articles)))
    end
  end

  def articles(number)
    articles = Articles.new 
    Array.new(number) { an_article.build }.each do |article|
      articles << article
    end

    articles
  end
end
