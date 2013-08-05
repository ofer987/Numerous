require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  setup do
    @valid_article = Article.new do |article|
      article.gazette = gazettes(:peru_stories)
      article.title = "Interesting Story"
      article.sub_title = "You Should Read This!"
      article.content = "Lots of interesting things to read here."
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
  
  test "should be able to modify an article's created_at date" do
    new_article = Article.new(gazette_id: gazettes(:peru_stories).id, created_at: DateTime.new(2012, 5, 12))
    
    assert new_article.save, "should be able to modify an article's created_at datetime"
    assert new_article.created_at == DateTime.new(2012, 5, 12), "the article cannot save its selected datetime"
  end
end
