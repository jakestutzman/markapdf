require 'rubygems'
require 'rdiscount'
require 'uv'
require 'thor'
require 'fileutils'

require 'lib/prince'
require 'lib/thor_helpers'

class ToPdf < Thor
  include ThorHelpers
  
  # Create
  # @book-location => The root directory of book which contains the layout, and in it stylesheets, chapters and the pdf_template
  #
  desc 'create',  "Create a PDF Document from Markdown file(s)."
  method_options  "--book-location"   => :required,
                  "--css"             => :optional,
                  "--code-lang"       => :optional,
                  "--book-name"       => :optional
  def create
    @book_location   = File.join(options['book-location'])
    @css             = options['css']           || 'amy'
    @lang            = options['code-lang']     || 'ruby'
    @bookname        = options['book-name']     || 'pdfbook'
    @html_book       = create_html_book('book-location' => @book_location, 'css' => @css, 'lang' => @lang)
    @prince          = Prince.new
    
    
    @prince.add_style_sheets(merge_stylesheets.join(','))
    
    File.open("#{File.join(@book_location, 'pdf_output', @bookname)}.pdf", 'w') do |f|
      f.puts @prince.pdf_from_string(File.new(@html_book).read)
    end
  end
  
end

