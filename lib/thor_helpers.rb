module ThorHelpers

  # Create the path if it doesn't already exist
  def create_if_missing(path)
    FileUtils.mkdir(path) unless File.exists?(path)
  end
  
  # Create the HTML for our PDF conversion
  def to_html(output_path, markdown_file)
    output = File.new( File.join(output_path, markdown_file) ).read
    RDiscount.new(output).to_html
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
  
  # Takes the path to the chapters and adds them all together
  # into one file and outputs that, in markdown, to the output_path specified
  def merge_chapters(chapter_path, output_path)
    File.open(File.join(output_path, 'book.markdown'), 'w+') do |f|
      Dir["#{chapter_path}/*.markdown"].sort.each do |dir_path|
        f << File.new(dir_path).read + "\r\n"
      end
    end
    return File.join(output_path, 'book.markdown')
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
  def create_html_book(options)
    @_output_path = File.join(options['book-location'], 'pdf_output')
    self.create_if_missing(@_output_path)
    @_book        = self.merge_chapters(File.join(options['book-location'], 'layout/chapters'), @_output_path)
    @_markdown    = self.to_html(@_output_path, @_book)

    File.open(File.join(@_output_path, 'book.html'), 'w') do |f|
      pdf_layout(@_markdown,  options.merge('template' => File.join(options['book-location'], 'layout/pdf_template.html') ) )
    end
    
    return File.join(@_output_path, 'book.html')
  end
  
  
end