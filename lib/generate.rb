%w[fileutils].each { |r| require r }

# Generate
# 
# Generate our book layout to any given location
#
# Generate::Book.now(location)
#
module Generate
 
 class Book
    attr_reader :location, :book
    
    # 
    # location => "The location you want to install the book framework"
    #
    def initialize(location=nil)
      @location = File.expand_path(location) || Dir.pwd
      @book     = File.expand_path('book')
    end
    
    
    # Convience
    # Generate::Book.now
    #
    def self.now(location=nil)
      gen = Generate::Book.new(location)
      gen.clone
    end
    
    
    # Clone
    #
    # Copies the book location over to the desired location.
    #
    def clone
      FileUtils.cp_r( @book, @location )
    end
    
 end 
  
end