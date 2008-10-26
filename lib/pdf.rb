require 'lib/html'
require 'lib/prince'
require 'lib/style_sheets'

module PDF
  
  class Book
    attr_reader :book_location, :output_path, :bookname, :code_css, :code_lang
    
    # Initializer
    #
    # initialize sets up our book location and our book output
    # it will create our output_path folder if it doesn't exist
    #
    # If you have not created the HTML version of the book
    # look at the options in the HTML::Book class. The options
    # here, will be passed to HTML::Book class to create the 
    # HTML book if it doesn't exist.
    #
    # @param {:bookname      => "The name of the book"
    #         :code_css      => "The CSS file for Syntax Highlighting" }
    #
    def initialize(options={})
      @options        = options
      @book_location  = File.join(Dir.pwd, "book")
      @bookname       = options["bookname"]      || "MyBook"
      @code_css       = options["code-css"]      || "lazy" # TODO: Pull this out.
      create_html_book
    end
    
    
    # PDF::Book.make
    #
    # Class method for a single call to create a PDF Book
    #
    # @params are the same as the initialize method above
    #
    def self.make(options={})
      book = PDF::Book.new(options)
      book.create
    end
    
    
    # Creates our PDF Book
    #
    def create
      prince      = Prince.new
      stylesheets = StyleSheets.merge(@book_location)
      prince.add_style_sheets(stylesheets)

      File.open("#{File.join(@book_location, 'output', @bookname)}.pdf", 'w') do |f|
        f.puts prince.pdf_from_string( 
          File.new( 
            File.join(@book_location, "output/#{@bookname}.html") 
          ).read 
        )
      end
    end

    
    
    # create_html_book
    #
    # Creates the HTML book if it doesn't exist
    #
    def create_html_book
      HTML::Book.make(@options) unless File.exists?(File.join(@book_location, "output/#{@bookname}.html"))
    end
    
  end
  
end