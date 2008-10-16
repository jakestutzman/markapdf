require 'thor'

require 'lib/prince'
require 'lib/html'
require 'lib/pdf'
require 'lib/generate'
require 'lib/fetch'

class MarkaPDF < Thor
  
  # Create HTML Book
  #
  desc 'html_book',   "Create an HTML Document from Markdown file(s)."
  method_options      "--book-location"   => :optional,
                      "--bookname"        => :optional,
                      "--code-css"        => :optional,
                      "--code-lang"       => :optional
  def html_book
    HTML::Book.make(options)
  end
  
  
  # Create PDF Book
  #
  desc 'pdf_book',    "Create a PDF Document from Markdown file(s)."
  method_options      "--book-location"   => :optional,
                      "--bookname"        => :optional,
                      "--code-css"        => :optional,
                      "--code-lang"       => :optional
  def pdf_book
    PDF::Book.make(options)
  end
  
  
  # Generate Book Layout
  #
  desc 'generate',    "Generate the Book Layout"
  method_options      "--location"        => :optional
  def generate
    Generate::Book.now(options['location'])
  end
  
  
  # Fetch a Book
  #
  desc 'fetch',       "Fetch a Book off of Github"
  method_options      "--url"             => :required,
                      "--type"            => :required,
                      "--location"        => :optional
  def fetch
    Fetch::Book.from(options)
  end
  
end