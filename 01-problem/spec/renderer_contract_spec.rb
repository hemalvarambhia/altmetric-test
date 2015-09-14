require_relative '../lib/doi'
require_relative '../lib/issn'
require_relative '../lib/journal'
require_relative '../lib/article'
require_relative '../lib/articles'

shared_examples "a renderer" do
  describe "Rendering no articles" do
    it "contains nothing" do
      no_articles = Articles.new([])

      rendered_articles = render(no_articles)

      expect(rendered_articles).to be_empty
    end
  end

  describe "Rendering of 1 article" do
    context "when the article has one author" do
      before(:each) do
        @all_articles = Articles.new(
            [
                Article.new(
                    {
                        doi: DOI.new("10.1234/altmetric0"),
                        title: "Title of Article",
                        author: ["Name of Author"],
                        journal: Journal.new(
                            ISSN.new("0378-5955"),
                            "Name of Journal")
                    }
                )
            ])
      end

      it "contains the details of the article" do
        rendered_articles = render(@all_articles)

        expect(rendered_articles).to(eq(expected_format(@all_articles)))
      end
    end
  end

  describe "Rendering two articles" do
    before(:each) do
      @all_articles = Articles.new(
          [
              Article.new(
                  {
                      doi: DOI.new("10.1234/altmetric0"),
                      title: "Title of Article",
                      author: ["Name of Author"],
                      journal: Journal.new(
                          ISSN.new("0378-5955"),
                          "Name of Journal")
                  }
              ),
              Article.new(
                  {
                      doi: DOI.new("10.1234/altmetric1"),
                      title: "Different Title",
                      author: ["Different Author"],
                      journal: Journal.new(
                          ISSN.new("0024-9319"),
                          "Different Journal")
                  }
              )
          ])
    end

    it "contains the details of both articles" do
      rendered_articles = render(@all_articles)

      expect(rendered_articles).to(eq(expected_format(@all_articles)))
    end
  end

  describe "Rendering many articles" do
    before(:each) do
      @all_articles = Articles.new(
          [
              Article.new(
                  {
                      doi: DOI.new("10.1234/altmetric0"),
                      title: "Title of Article",
                      author: ["Name of Author"],
                      journal: Journal.new(
                          ISSN.new("0378-5955"),
                          "Name of Journal")
                  }
              ),
              Article.new(
                  {
                      doi: DOI.new("10.1234/altmetric1"),
                      title: "Different Title",
                      author: ["Different Author"],
                      journal: Journal.new(
                          ISSN.new("0024-9319"),
                          "Different Journal")
                  }
              ),
              Article.new(
                  {
                      doi: DOI.new("10.1234/altmetric2"),
                      title: "Another Title",
                      author: ["Another Author"],
                      journal: Journal.new(
                          ISSN.new("0032-1478"),
                          "Another Journal")
                  }
              )
          ])
    end

    it "contains the details of every article" do
      rendered_articles = render(@all_articles)

      expect(rendered_articles).to(eq(expected_format(@all_articles)))
    end
  end
end
