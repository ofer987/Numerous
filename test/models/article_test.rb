require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  setup do
    @valid_article = Article.new do |article|
      article.title = "Interesting Story"
      article.sub_title = "You Should Read This!"
      article.content = "Lots of interesting things to read here."
      article.published_at = DateTime.now
    end
  end
  
  test "should be able to modify an article's published_at date" do
    new_article = Article.new(published_at: DateTime.new(2012, 5, 12).getutc)
    
    assert new_article.save, "should be able to modify an article's published_at datetime"
    assert new_article.published_at.getutc == DateTime.new(2012, 5, 12).getutc, "the article cannot save its selected datetime"
  end

  test "article's default time published_at is now" do
    now_expected = DateTime.now.getutc
    new_article = Article.new

    assert new_article.published_at.getutc.year == now_expected.year &&
               new_article.published_at.getutc.month == now_expected.month &&
               new_article.published_at.getutc.day == now_expected.day

    assert new_article.valid?
  end
  
  test 'should save article' do
    assert @valid_article.save
  end

  test 'article should have tags' do
    article = articles(:cusco_trip)
    assert article.tags.count == 1

    article.tags << Tag['england']
    article.tags << Tag.find_or_init_by_name('toronto')
    article.save!

    assert article.tags.count == 3
    assert article.tags.find_by_name('england')
    assert article.tags.find_by_name('toronto')
  end

  test 'should add tags when setting the tags_attributes property' do
    article = Article.new(title: 'new article',
                          content: 'Hello from Canada')
    article.tags_attributes = 
      { tags_attributes: 'toronto , montreal, quebec city' }
    assert article.tags.to_a[0].name == 'toronto'
    assert article.tags.to_a[1].name == 'montreal'
    assert article.tags.to_a[2].name == 'quebec city'
  end

  test 'should convert tag names to lower case' do
    article = Article.new
    article.tags_attributes = { tags_attributes: 'Toronto' }
    assert article.tags.to_a[0].name == 'toronto'
  end

  test 'article content should be displayed in paragraph form' do
    article = Article.new(content: "Hello\nWorld")

    assert "<p>Hello</p><p>World</p>" == article.content
  end
end
