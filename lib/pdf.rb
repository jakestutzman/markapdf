module PDF
  
  class Book
    
    
    def initialize()
      
    end
    
    
    # Creates our PDF Book
    #
    # options                                                       -- Hash
    #   :name       => The Name of the Book                         -- String
    #   :location   => The Location of where the Book Layout lives  -- String
    #   :make_html  => Has the HTML Book been created?              -- Boolean
    #
    #
    def create(options={})
      bookname      = options[:name]      || "pdfbook"
      book_location = check_book_location(options[:location])
      html_book(book_location) if options[:make_html]

      prince  = Prince.new

      File.open("#{File.join(book_location, 'output', bookname)}.pdf", 'w') do |f|
        f.puts prince.pdf_from_string( 
          File.new( 
            File.join(book_location, "output/book.html") 
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
      def merge_stylesheets(book_location=nil)
        book_location   = check_book_location(book_location)
        stylesheets     = File.join(book_location, "layout/stylesheets")

        sheets = Array.new
        Dir["#{stylesheets}/*.css"].sort.each do |css|
          sheets << css
        end
        return sheets
      end
    
  end
  
end