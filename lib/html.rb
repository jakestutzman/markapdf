%w[rubygems rdiscount fileutils uv].each { |r| require r }

module HTML
  
  class Book
    attr_reader :book_location, :output_path, :bookname, :code_css, :code_lang
    
    
    # Initializer
    #
    # initialize sets up our book location and our book output
    # it will create our output_path folder if it doesn't exist
    #
    # @param {:book_location => "where the root of the book is located",
    #         :code_css      => "What stylesheet do you want to use for code highlighting",
    #         :bookname      => "The name of the book",
    #         :code_lang     => "Pass in the Language for the code if you only covering 1 language"}
    #
    def initialize(options={})
      @book_location  = options["book-location"] || File.join(Dir.pwd, "book")
      @code_css       = options["code-css"]      || "amy"
      @bookname       = options["bookname"]      || "MyBook"
      @code_lang      = options["code-lang"]     || nil
      @output_path    = File.join(@book_location, "output")
      create_if_missing(@output_path)
    end
    
    
    # Creates our HTML Book
    #
    # book_location => The Location of where the Book Layout live   -- String
    #
    # It creates the HTML Book in the book/output file (output file is 
    # created, if it doesn't exist)
    #
    def create
      @book = merge_chapters(File.join(@book_location, "layout/chapters"))
      to_html(@book)
      template
      clean_up
    end
    
    
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
      def to_html(markdown_path)
        output = File.new( markdown_path ).read
        File.open(File.join(@output_path, "book.html"), 'w') do |f| 
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
      # 003_A_New_Journey.markdown
      #
      # Returns the Path to the Book that has all the Chapters in it
      def merge_chapters(chapter_path)
        File.open(File.join(@output_path, 'book.markdown'), 'w+') do |f|
          Dir["#{chapter_path}/*.markdown"].sort.each do |dir_path|
            f << File.new(dir_path).read + "\r\n"
          end
        end
        return File.join(@output_path, 'book.markdown')
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
      def template
        html          = File.new(File.join(@output_path, "book.html")).read
        html_template = File.new(File.join(@book_location, 'layout/template.html')).read
        html_template.gsub!("#body", html)
        html_template = code_highlight(html_template)
        File.open(File.join(@output_path, "#{@bookname}.html"), 'w+') do |f|
          f << html_template
        end
      end
      
      
      def clean_up
        FileUtils.rm(File.join(@output_path, 'book.html'))
        FileUtils.rm(File.join(@output_path, 'book.markdown'))
      end

      # Code Highlighting
      #
      # html_template =>  the same HTML template from our template 
      #                   method above.
      #
      def code_highlight(html_template)
        html_template.gsub!(/<pre><code>.*?<\/code><\/pre>/m) do |code|
          
          if code.match(/::.*?::/)
            @code_lang = code.split("::")[1]
            code.gsub!(/::.*?::/, '')
          end
          
          code = code.gsub('<pre><code>', '').gsub('</code></pre>', '').gsub('&lt;', '<').gsub('&gt;', '>').gsub('&amp;', '&')
          
          Uv.parse(code, "xhtml", @code_lang, false, @code_css)
        end
        
        return html_template
      end
      
  end
  
end