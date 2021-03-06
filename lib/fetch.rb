require 'fileutils'
require 'lib/generate'
require 'lib/mixins/file_helper'

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
# 2nd problem, code highlighting - let the copier do this.

module Fetch
  
  class Book
    include FileHelper
    
    attr_reader :url, :location, :basename, :chapter_loc
    
    # init
    #
    # Arguments Required
    #
    #   :url      => the url to where the book is located
    #   :type     => markdown or textile (whatever extension is used: mdown, etc.)
    #
    # Optional Arguments
    #
    #   :location => where to install this if empty, assumes current directory
    #
    def initialize(options)
      @url, @type   = options[:url], options[:type]
      @location     = File.expand_path(options[:location]) || Dir.pwd
      @basename     = File.basename(@url).split('.').first
      @chapter_loc  = File.join(@location, "book/layout/chapters/")
    end
    
    
    # From
    #
    # Convience class method
    # Fetch::Book.from(options)
    #
    def self.from(options)
      book = Fetch::Book.new(options)
      book.generate_book
      book.pull
      book.copy
      # clean_up File.join(@location, @basename)
    end
    
    
    # Pull
    #
    # We're only going to support git at the moment because
    # that is what I use.
    #
    def pull
      FileUtils.cd(@location)
      `git clone #{@url}` unless File.exists?(File.join(@location, @basename))
    end
    
    
    # Copy
    #
    # Copy over the files we've collected from our pull request.
    #
    def copy
      Dir.glob( File.join(@location, @basename, '**', "*.#{@type}") ).each do |chapter|
        FileUtils.cp(chapter, @chapter_loc) unless File.exists?( File.join(@chapter_loc, File.basename(chapter)) )
      end
    end
    
    
    # Write
    #
    # Generates the Book Layout.
    #
    def generate_book
      Generate::Book.now(@location) unless File.exists?( File.join(@location, 'book') )
    end
    
  end
  
end