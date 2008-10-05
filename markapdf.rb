require 'thor'

require 'lib/prince'
require 'lib/html'
require 'lib/pdf'

class MarkaPDF < Thor
  
  # Create HTML Book
  #
  desc 'html_book',   "Create an HTML Document from Markdown file(s)."
  method_options      "--book-location"   => :optional,
                      "--bookname"        => :optional,
                      "--code-css"        => :optional,
                      "--code-lang"       => :optional,
                      "--markup"          => :optional
  def html_book
    book = HTML::Book.new(options)
    book.create
  end
  
  
  # Create PDF Book
  #
  desc 'pdf_book',    "Create a PDF Document from Markdown file(s)."
  method_options      "--book-location"   => :optional,
                      "--bookname"        => :optional,
                      "--code-css"        => :optional,
                      "--code-lang"       => :optional,
                      "--markup"          => :optional
  def pdf_book
    book = PDF::Book.new(options)
    book.create
  end
  
end