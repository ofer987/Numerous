require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  setup do
    @valid_article = Article.new do |article|
      article.gazette = gazettes(:peru_stories)
      article.title = "Interesting Story"
      article.sub_title = "You Should Read This!"
      article.content = "Lots of interesting things to read here."
      article.published_at = DateTime.now
    end
  end
  
  test "article should belong to a gazette" do
    new_article = Article.new
    
    assert new_article.invalid?, 'should not be able to save an article without belonging to a gazette'
    
    new_article.gazette = gazettes(:peru_stories)
    assert new_article.valid?, 'should be able to save an article that belongs to a gazette'
  end
  
  test "should remove carriage returns and newlines in content field if convert to html" do
    original_content = 
    'Hello
    There is a newline on the previous line
    
    '
    @valid_article.content = original_content
    @valid_article.convert_content_to_html

    assert (@valid_article.content =~ /\r/) == nil, "article's content should not contain a carriage return character"
    assert (@valid_article.content =~ /\n/) == nil, "article's content should not contain a newline character"
  end
  
  test "should not remove carriage returns and newlines in content field if convert to html" do
    original_content = 
    'Hello
    There is a newline on the previous line
    
    '
    @valid_article.content = original_content
    
    assert_equal @valid_article.content, original_content, "article's should not contain carriage return or newline characters"
  end
  
  test "should be able to modify an article's published_at date" do
    new_article = Article.new(gazette_id: gazettes(:peru_stories).id, published_at: DateTime.new(2012, 5, 12).getutc)
    
    assert new_article.save, "should be able to modify an article's published_at datetime"
    assert new_article.published_at.getutc == DateTime.new(2012, 5, 12).getutc, "the article cannot save its selected datetime"
  end

  test "article's default time published_at is now" do
    now_expected = DateTime.now.getutc
    new_article = Article.new(gazette_id: gazettes(:peru_stories).id)

    assert new_article.published_at.getutc.year == now_expected.year &&
               new_article.published_at.getutc.month == now_expected.month &&
               new_article.published_at.getutc.day == now_expected.day

    assert new_article.valid?
  end

  test "article has default published_at date" do
    @valid_article.published_at = nil

    assert @valid_article.valid?, "Published_at = nil should have been converted to DateTime.now"
  end
end
