require 'json'
require_relative './json_rendering_helper'

describe "Rendering articles to JSON" do
  include JSONRenderingHelper
  it_behaves_like "a renderer"

  describe "Rendering 1 article in JSON" do
    context "when the article has multiple authors" do
      before(:each) do
        @all_articles = Articles.new(
            [
                Article.new(
                    {
                        doi: DOI.new("10.1234/altmetric0"),
                        title: "Title of Article",
                        author: ["Author 1", "Author 2", "Author 3"],
                        journal: Journal.new(
                            ISSN.new("0378-5955"),
                            "Name of Journal")

                    }
                )
            ])
      end

      it "renders the authors as a comma-separated string" do
        rendered_articles = render(@all_articles)

        expect(rendered_articles.first["author"]).to(
            eq("Author 1, Author 2, Author 3"))
      end
    end
  end
end
