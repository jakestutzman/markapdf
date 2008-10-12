%w[uri net/http fileutils].each { |r| require r }

# Fetch
#
# What if I don't want to write a book, but instead see a book that 
# someone else is working on and would like to format it better so
# I can read it myself or produce it? 
#
# Secondly, how are we gonna handle the code blocks because the author
# hasn't set up his book as we need it to be for code blocks? 
#
# 1st problem, let's get the book and allow the user to get it from
# anywhere, as long as there is some URL.
#
# 2nd problem, code highlighting.

module Fetch
  
  class Book
    
    # init
    #
    # Options Required
    #
    #   :url    => the url to where the book is located
    #   :type   => html | git
    #
    def initialize(options)
      @options = options
    end
    
    
    # From
    #
    # Convience class method
    # Fetch::Book.from(options)
    #
    def self.from(options)
      book = Fetch::Book.new(options)
    end
    
    
    # Route
    #
    #
    def route
      
    end
    
    
    # Git
    #
    # A lot of books are on Git, so we need to provide a way to get
    # those books too.
    #
    def git
      
    end
    
    
    # HTML
    #
    # Some books are already in HTML, so we want to allow them to be pulled
    # down and turned into PDF books.
    #
    def html
      
    end
    
    
    # Get
    #
    # Use this to get either our html or git book
    #
    def get
      
    end
    
  end
  
end