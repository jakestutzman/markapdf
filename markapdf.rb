require 'rubygems'
require 'rdiscount'
require 'uv'
require 'fileutils'
require 'thor'

require 'lib/prince'
require 'lib/book_helpers'

class ToPdf < Thor
  include BookHelpers
  
  # Create
  #
  desc 'create',  "Create a PDF Document from Markdown file(s)."
  method_options  "--book-location"   => :required,
                  "--book-name"       => :optional
  def create

  end
  
end

