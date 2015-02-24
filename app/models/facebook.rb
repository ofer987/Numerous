class Facebooker
  def initialize graph
    @graph = graph
  end

  def post message
    @graph.put_connections("me", "feed", message: message)
  end
end
