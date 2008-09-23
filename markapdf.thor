require 'rubygems'
require 'rdiscount'
require 'uv'
require 'thor'
require 'fileutils'

require 'lib/prince'
require 'lib/thor_helpers'

class ToPdf < Thor
  include ThorHelpers
  
  desc 'create',  "Create a PDF Document from Markdown file(s)."
  method_options  "--markdown-files"  => :required
  def create
    pdf_template    = File.join("book/layout/pdf_template.html")
    output_location = File.join(Dir.pwd, 'pdf_output')
    
    create_if_missing(output_location)
    @book     = merge_chapters(options['markdown-files'], output_location)
    @markdown = to_html(output_location, @book)
  end
  
end

