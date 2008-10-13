require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + "/../lib/html.rb"

describe HTML::Book do

  before(:each) do
    @options = {
      'book-location'   => "book",
      'bookname'        => "SpecBook",
      'code-css'        => "lazy",
      'code-lang'       => "javascript"
    }
  end
  

  describe "The initialize method" do

    it "should setup the variables when the options hash is passed in" do
      @book = HTML::Book.new(@options)
      @book.book_location.should  == "book"
      @book.bookname.should       == "SpecBook"
      @book.code_css.should       == "lazy"
      @book.code_lang.should      == "javascript"
      @book.output_path.should    == "book/output"
    end
    
    
    it "should setup the variables based on the defaults, when no options hash is passed in" do
      @book = HTML::Book.new
      @book.book_location.should  == File.join(Dir.pwd, "book")
      @book.bookname.should       == "MyBook"
      @book.code_css.should       == "lazy"
      @book.code_lang.should      == "ruby"
      @book.output_path.should    == File.join(Dir.pwd, "book/output")
    end

  end # end the initialize method
  
  
  describe "Book Type" do
    
    it "should return the correct book type based on the first chapter found in the chapter path" do
      @book = HTML::Book.new(@options)
      @book.book_type.should == "markdown"
    end
    
  end
  
end