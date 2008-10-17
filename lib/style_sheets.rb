%w[fileutils].each { |r| require r }

# StyleSheets Class
#
# This class handles all the stylesheet related work that the book
# supports. Things like merging stylesheets together for PDF Book
# creation as well as providing some utility methods to move 
# Syntax Highlighting StyleSheets to the book layout, list the
# supported stylesheets, move all stylesheets to the book layout
# and insert the stylesheets into the head of the Book's HTML template
# file.
#
# There are two ways to initialize this Class:
#
# StyleSheets.new
# StyleSheets.utils
#
# The #new option is a leaner entrance to do book merging for the PDF
# Book. The utils entrance is for doing some more utility things, as
# mentioned above.
#
#
class StyleSheets
  
  # StyleSheets.new
  #
  # options hash:
  #   location  => Where the book is located
  #   css       => The name of the Syntax Highligher CSS File
  #
  def initialize(options={})
    @book_location  = options[:location]
    @code_css       = options[:css]
  end
  
  
  # StyleSheets.utils
  #
  # options hash:
  #   location  => Where the book is located
  #   css       => The name of the Syntax Highligher CSS File
  #
  # We can instantiate this method to access our css utilities in our class here.
  # Just doing the #new, allows for less loading and populating so we can just
  # execute (for example) the merge method.
  #
  def self.utils(options={})
    css = Style::Sheets.new(options)
    @css_core_file      = File.join("lib/stylesheets/")
    @css_core_file_list = Array.new
    all_css_files
  end
  
  
  # List
  #
  # List out the names that we support for CSS Syntax Highlighting
  def list
    @css_core_file_list.each { |css| puts css }
  end
  
  
  # All CSS Files
  # 
  # Iterates through our internal stylesheets and appends the basename
  # to an array
  #
  def all_css_files
    Dir["#{@css_core_file}/*.css"].sort.each do |css|
      @css_core_file_list << File.basename(css)
    end
  end
  
  
  # Move All
  #
  # Can't decide what CSS file to use for Syntax Highlighting?
  # Want to play around with different ones without having to
  # move single CSS files into your book css folder, then move
  # them all to your book project to play around with.
  #
  def move_all
    book_css_dir = File.join(@book_location, 'layout/stylesheets/highlight/')
    FileUtils.mkdir(book_css_dir) unless File.exists?(book_css_dir)
    FileUtils.cp_r(book_css_dir, @css_core_file) # TODO: Test this
  end
  
  
  # TODO:
  #
  # We'll want a method to insert the stylesheets into the head of
  # the HTML template.
  #

  
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
  #
  def merge
    stylesheets = File.join(@book_location, "layout/stylesheets")
    sheets      = Array.new
  
    Dir["#{stylesheets}/*.css"].sort.each { |css| sheets << css }
    # sheets << File.join(stylesheets, "highlight/#{@code_css}.css")
    return sheets
  end
  
  
end