class BooksController < ApplicationController
  before_action :set_goodreads_client
  
  skip_before_action :authorize, only: [:read] 
  
  def read
    dan_id = 7297148
    read_shelf = 'read'
    per_page_results = 200

    shelf = @client.shelf(dan_id, read_shelf, {per_page: per_page_results, page: 1})
    
    # Get the remaining pages
    page = 2
    while true 
      shelf.books.concat @client.shelf(dan_id, read_shelf, {per_page: per_page_results, page: page}).books
      
      break if shelf.books.count == shelf.total
      page += 1
    end
    # We have all the books
    shelf.end = shelf.total
    
    @sorted_books = shelf.books.sort_by { |book| get_read_at(book) }.reverse!
  end
  
  private
  
  def set_goodreads_client
    @client = Goodreads.new
  end
  
  def get_read_at(book)
    if book.read_at.nil?
      read_at = DateTime.new(year=0, month=1)
    else
      read_at = DateTime.strptime(book.read_at, "%a %b %d %H:%M:%S %z %Y")
    end

    read_at
  end
end
