%w[fileutils rubygems hpricot].each { |r| require r }
require 'lib/mixins/error_classes'
require 'lib/mixins/file_helper'

include ErrorClasses

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
#
class StyleSheets
  include FileHelper
  
  # StyleSheets.new
  #
  # options hash:
  #   location  => Where the book is located
  #   css       => The name of the Syntax Highligher CSS File
  #
  def initialize(options)
    @book_location        = File.expand_path(options[:location])
    @code_css             = options[:css]
    @css_core_file        = File.join("lib/stylesheets/")
    @css_core_file_list   = []
    all_css_files
  end
  
  
  # List
  #
  # List out the names that we support for CSS Syntax Highlighting
  def list
    @css_core_file_list.each { |css| puts css } and return true
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
    create_if_missing(book_css_dir)
    Dir["#{@css_core_file}/*.css"].each { |css| FileUtils.cp(css, book_css_dir) }
  end
  
  
  # Move CSS
  #
  # Move a single CSS file to the books layout directory.
  #
  # TODO: Need to be able to match the CSS file if it is typed incorrectly
  #
  def move_css
    book_css_dir  = File.join(@book_location, 'layout/stylesheets/')
    code_css_file = File.join(@css_core_file, "#{@code_css}.css")
    FileUtils.cp(code_css_file, book_css_dir) 
    raise CSSNotFound unless File.exists?(code_css_file)
  end
  
  
  # TODO:
  #
  # We'll want a method to insert the stylesheets into the head of
  # the HTML template.
  #

  
  # Merge -> Class Method
  #
  # StyleSheets.merge(book_location)
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
  # book_location [String] =>  The Location of where the Book Layout lives
  #
  # For ordering, make sure to name your stylesheets like:
  # 001_reset.css
  # 002_base.css
  # 003_typeography.css
  #
  # Returns an array of stylesheets within
  #
  def self.merge(book_location)
    stylesheets = File.join(File.expand_path(book_location), "layout/stylesheets")
    sheets      = Array.new
  
    Dir["#{stylesheets}/*.css"].sort.each { |css| sheets << css }
    # sheets << File.join(stylesheets, "highlight/#{@code_css}.css")
    return sheets
  end
  
  
end