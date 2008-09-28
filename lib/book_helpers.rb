module BookHelpers

  # Creates our HTML Book
  #
  # book_location => The Location of where the Book Layout live   -- String
  #
  # It creates the HTML Book in the book/output file (output file is 
  # created, if it doesn't exist)
  #
  def html_book(book_location=nil)
    book_location   = check_book_location(book_location)
    output          = File.join(book_location, "output")
    create_if_missing(output)
    
    book            = merge_chapters(File.join(book_location, "layout/chapters"), output)
    to_html(output, book)
  end
  
  
  # Creates our PDF Book
  #
  # options                                                       -- Hash
  #   :name       => The Name of the Book                         -- String
  #   :location   => The Location of where the Book Layout lives  -- String
  #   :make_html  => Has the HTML Book been created?              -- Boolean
  #
  # TODO: Add in HTML Template
  #
  def pdf_book(options={})
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
  
  
  # Protected Methods
  protected


    # Create the path if it doesn't already exist
    #
    # path => what file you want to create and where          -- Sting / File Path
    #
    def create_if_missing(path)
      FileUtils.mkdir(path) unless File.exists?(path)
    end


    # Create the HTML Version of the Book
    # Takes 2 parameters
    # output_path     =>  where the HTML version of the book 
    #                     will be saved                       -- String / File Path
    # markdown_path   =>  where the MarkDown version is 
    #                     located                             -- String / File Path
    #
    def to_html(output_path, markdown_path)
      output = File.new( markdown_path ).read
      File.open(File.join(output_path, "book.html"), 'w') do |f| 
        f << RDiscount.new(output).to_html
      end
    end
    
    
    # Merges all the Chapters together into one file
    #
    # chapter_path      =>  where all the chapters are located  -- String / File Path
    #
    # output_path       =>  where the 1 Markdown file will 
    #                       be saved that contains all the 
    #                       chapters                            -- String / File Path
    #
    # For ordering, make sure to name your chapters like:
    # 001_Introduction.markdown
    # 002_Heading_Home.markdown
    # 003_A_New_Lesson.markdown
    #
    # Returns the Path to the Book that has all the Chapters in it
    def merge_chapters(chapter_path, output_path)
      File.open(File.join(output_path, 'book.markdown'), 'w+') do |f|
        Dir["#{chapter_path}/*.markdown"].sort.each do |dir_path|
          f << File.new(dir_path).read + "\r\n"
        end
      end
      return File.join(output_path, 'book.markdown')
    end
    
    
    
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
    
    
    # check_book_location
    #
    # Returns either the default book location or
    # the passed in parameter as the book location.
    #
    # Returns the book_location
    def check_book_location(book_location)
      book_location ||= File.join(Dir.pwd, "book")
      return book_location
    end
    
    
    # Template
    # 
    # This will give more control over the look & feel of the
    # PDF book. The Template is an HTML based template. 
    #
    # book_location =>  The Location of where the Book Layout lives  -- String / File Path
    #
    # Returns the complete HTML, template + markdown files as
    # a complete one piece HTML book that can then be turn into
    # a PDF book.
    # 
    def template(book_location=nil, html)
      book_location = check_book_location(book_location)
      html_template = File.new(File.join(book_location, 'layout/template.html')).read
      html_template.gsub!("#body", html)
      return html_template
    end
    
    
    # Code Highlighting
    #
    # html_template =>  the same HTML template from our template 
    #                   method above.
    #
    # TODO: Remove options hash, it should know the language and it should
    #       be able to figure out what stylesheet is to be used
    def code_highlight(html_template)
      html_template.gsub!(/<pre><code>.*?<\/code><\/pre>/m) do |code|
        code = code.gsub('<pre><code>', '').gsub('</code></pre>', '').gsub('&lt;', '<').gsub('&gt;', '>').gsub('&amp;', '&')
        # Uv.parse(code, "xhtml", options['lang'], false, options['css'])
      end
    end

end