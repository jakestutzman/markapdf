require 'rubygems'
require 'rdiscount'
require 'uv'
require 'thor'
require 'fileutils'

require 'lib/prince'
require 'lib/book_helpers'

class ToPdf < Thor
  include BookHelpers
  
  # Create
  #
  desc 'create',  "Create a PDF Document from Markdown file(s)."
  method_options  "--book-location"   => :required,
                  "--css"             => :optional,
                  "--code-lang"       => :optional,
                  "--book-name"       => :optional
  def create

  end
  
end

