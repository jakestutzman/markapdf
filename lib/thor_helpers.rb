module ThorHelpers

  # Creates our HTML Book
  # Takes the book location as an optional parameter
  # If not passed, it assumes you are in the directory above the book root
  #
  # It creates the HTML Book in the book/output file (output file is created, if it doesn't exist)
  def html_book(book_location=nil)
    book_location ||= File.join(Dir.pwd, "book")
    output          = File.join(book_location, "output")
    create_if_missing(output)
    
    book            = merge_chapters(File.join(book_location, "layout/chapters"), output)
    to_html(output, book)
  end
  
  
  # Creates our PDF Book
  # Takes the book location as an optional parameter
  # If not passed, it assumes you are in the directory above the book root
  #
  # First, it creates the HTML Version of the Book
  def pdf_book(book_location=nil, bookname=nil)
    bookname      ||= "pdfbook"
    book_location ||= File.join(Dir.pwd, "book")
    html_book(book_location)
    prince  = Prince.new
    
    File.open("#{File.join(book_location, 'output', bookname)}.pdf", 'w') do |f|
      f.puts prince.pdf_from_string( File.new( File.join(book_location, "output/book.html") ).read )
    end
  end
  
  
  # Protected Methods
  protected


    # Create the path if it doesn't already exist
    # Takes one parameter: path => what file you want to create and where
    def create_if_missing(path)
      FileUtils.mkdir(path) unless File.exists?(path)
    end


    # Create the HTML Version of the Book
    # Takes 2 parameters
    # output_path     => where the HTML version of the book will be saved
    # markdown_path   => where the MarkDown version is located
    #
    # Returns Nothing
    def to_html(output_path, markdown_path)
      output = File.new( markdown_path ).read
      File.open(File.join(output_path, "book.html"), 'w') { |f| f << RDiscount.new(output).to_html }
    end
    
    
    # Merges all the Chapters together into one file
    # Takes 2 parameters
    # chapter_path      => where all the chapters are located
    # output_path       => where the 1 Markdown file will be saved that contains all the chapters
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
    
    
    
    
    
  
    # Takes the markdown that is now html as well as an options hash
    # Highlights the code as specified.
    #
    # TODO: Need to think about how to highlight various different languages in one doc
    #       Language should not have to be specified by the user, when creating a book.
    #       The system should be smart enough to figure it out.
    #
    def pdf_layout(html, options)
      html_template = File.new(options['template']).read
      html_template.gsub!("#body", html)
      html_template.gsub!(/<pre><code>.*?<\/code><\/pre>/m) do |code|
        code = code.gsub('<pre><code>', '').gsub('</code></pre>', '').gsub('&lt;', '<').gsub('&gt;', '>').gsub('&amp;', '&')
        Uv.parse(code, "xhtml", options['lang'], false, options['css'])
      end
    end
  
  
    # Grab all the stylesheets from the stylesheets folder
    def merge_stylesheets
      sheets = Array.new
      Dir.foreach(File.join(options['book-location']), 'layout/stylesheets') do |filename|
        next unless filename.match(/css/)
        sheets << filename
      end
      return sheets
    end
  
    # Create our HTML Book that can later be processed into our PDF book
    # def create_html_book(options)
    #   @_output_path = File.join(options['book-location'], 'pdf_output')
    #   create_if_missing(@_output_path)
    #   @_book        = merge_chapters(File.join(options['book-location'], 'layout/chapters'), @_output_path)
    #   @_markdown    = to_html(@_output_path, @_book)
    # 
    #   File.open(File.join(@_output_path, 'book.html'), 'w') do |f|
    #     pdf_layout(@_markdown,  options.merge('template' => File.join(options['book-location'], 'layout/pdf_template.html') ) )
    #   end
    # 
    #   return File.join(@_output_path, 'book.html')
    # end
  
  
end