require 'lib/html'
require 'lib/prince'

module PDF
  
  class Book
    
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
    # @param {:book_location => "where the root of the book is located",
    #         :bookname      => "The name of the book"}
    #
    def initialize(options={})
      @options        = options
      @book_location  = options["book-location"] || File.join(Dir.pwd, "book")
      @bookname       = options["bookname"]      || "MyBook"
      @code_css       = options["code-css"]      || "amy"
      create_html_book
    end
    
    
    # Creates our PDF Book
    #
    def create
      prince  = Prince.new

      File.open("#{File.join(@book_location, 'output', @bookname)}.pdf", 'w') do |f|
        f.puts prince.pdf_from_string( 
          File.new( 
            File.join(@book_location, "output/#{@bookname}.html") 
          ).read 
        )
      end
    end
    
    
    protected
      
      # Grab all the stylesheets from the stylesheets folder
      #
      # If not passed, it assumes you are in the directory above 
      # the book root
      #
      # Searches the stylesheet directory, where the book layout 
      # template (book/) is located and adds all stylesheets, 
      # in order. 
      #
      # book_location =>  The Location of where the Book Layout lives  -- String / File Path
      #
      # For ordering, make sure to name your stylesheets like:
      # 001_reset.css
      # 002_base.css
      # 003_typeography.css
      #
      # Returns an array of stylesheets within
      def merge_stylesheets
        stylesheets     = File.join(@book_location, "layout/stylesheets")

        sheets = Array.new
        Dir["#{stylesheets}/*.css"].sort.each do |css|
          sheets << css
        end
        sheets << File.join(stylesheets, "highlight/#{@code_css}.css")
        return sheets
      end
      
      
      # create_html_book
      #
      # Creates the HTML book if it doesn't exist
      #
      def create_html_book
        html_book = File.join(@book_location, 'layout/output', "#{@bookname}.html")
        unless File.exists?(html_book)
          book = HTML::Book.new(@options)
          book.create
        end
      end
    
  end
  
end