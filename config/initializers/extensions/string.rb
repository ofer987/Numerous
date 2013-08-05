class String
  def to_html
    # It is assumed that the entry is written in paragraph form (at least one paragraph)
    html = "<p>#{self.strip}</p>"
    
    # replace every newline (and/or carriage return) with a </p<p>
    html = html.gsub(/(\r{0,1}\n{1})+/, "</p><p>")
  end
end