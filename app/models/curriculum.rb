class Curriculum
  def resume
    read_markdown "app/assets/markdown/20150205.markdown"
  end

  def cover_letter
    read_markdown "app/assets/markdown/cover-20150205.markdown"
  end

  private

  def read_markdown file_path
    # load curriculm markdown
    cv_markdown = File.read file_path, mode: 'rt'
    markdown_processor = MyMarkdown.new cv_markdown

    # return html
    markdown_processor.content
  end
end
