require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + "/../lib/generate.rb"
require 'fileutils'

describe Generate::Book, "with arguments" do
  
  before(:all) do
    @location = File.join('test_files')
    @gen = Generate::Book.new(@location)
  end
  
  it "should should set paths" do
    @gen.location.should == File.expand_path(@location)
    @gen.book.should == File.expand_path('book')
  end
  
  it "should clone the book directory to our specified location" do
    @gen.clone
    File.exists?(File.join(@location, 'book/layout')).should be_true
  end
  
  
  # TearDown
  after(:all) do
    location = File.expand_path(File.join('test_files'))
    FileUtils.rm_rf( File.join(location, 'book') )
  end
  
end