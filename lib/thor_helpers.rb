module ThorHelpers
  
  # Create the path if it doesn't already exist
  def create_if_missing(path)
    FileUtils.mkdir(path) unless File.exists?(path)
  end
  
  # Create the HTML for our PDF conversion
  def to_html(path, markdown_file)
    output = File.new( File.join(path, markdown_file) ).read
    RDiscount.new(output).to_html
  end
  
  def pdf_layout(html, path, options)
    html_template = File.new(options[:template]).read
    html_template.gsub!("#body", html)
    html_template.gsub!(/<pre><code>.*?<\/code><\/pre>/m) do |code|
      code = code.gsub('<pre><code>', '').gsub('</code></pre>', '').gsub('&lt;', '<').gsub('&gt;', '>').gsub('&amp;', '&')
      Uv.parse(code, "xhtml", options[:lang], false, options[:css])
    end
    return html_template
  end
  
  def merge_chapters(path, output)
    File.open(File.join(output, 'book.markdown'), 'w+') do |f|
      Dir["#{path}/*.markdown"].sort.each do |dir_path|
        f << File.new(dir_path).read + "\r\n"
      end
    end
    return File.join(output, 'book.markdown')
  end
  
  
  def create_html_book(outbound_path, markdown_files, options)
    self.create_if_missing(outbound_path)
    @_book      = self.merge_chapters(markdown_files, outbound_path)
    @_markdown  = self.to_html(outbound_path, @_book)
    
  end
end