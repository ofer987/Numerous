require 'test_helper'

class MyMarkdownTest < ActiveSupport::TestCase
  setup do
    @standard_markdown = <<-MARK
      # Hello
      ## Second Header

      This is a paragraph

      - bullet 1
      - bullet 2
    MARK

    markdown_renderer = Redcarpet::Render::HTML.new
    @markdown = Redcarpet::Markdown.new(markdown_renderer)
  end

  test 'should replace markdown for markdown-standard content' do
    my_markdown = MyMarkdown.new(@standard_markdown)

    assert my_markdown.content == @markdown.render(@standard_markdown),
      "MyMarkdown did not correctly interpolate standard Markdown.\n" +
      "result is:\n#{my_markdown.content}"
  end

  test 'should replace photo tags with html' do
    content = '[llama]'
    my_markdown = MyMarkdown.new(content)
    processed_content = my_markdown.content

    assert processed_content != content && !processed_content.blank?,
      "did not replace photo tag with html.\n" +
      "result is:\n#{my_markdown.content}"
  end

  test 'if photo does not exist then replace with the empty string' do
    content = 'Here is an invalid llama: [invalid_photo]'
    my_markdown = MyMarkdown.new(content)
    processed_content = my_markdown.content

    assert (processed_content =~ /Here is an invalid llama: /) >= 0,
      "the invalid photo was not replaced by the empty string" +
      "result is:\n#{my_markdown.content}"
  end

  test 'MyMarkdown returns blank string if input is nil or blank' do
    nil_content = MyMarkdown.new(nil).content

    refute nil_content.nil?
    assert nil_content.blank?

    blank_content = MyMarkdown.new('').content

    refute blank_content.nil?
    assert blank_content.blank?
  end
end
