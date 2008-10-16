module FileHelper
  
  # Create the path if it doesn't already exist
  #
  # path [String] => what file you want to create and where
  #
  def create_if_missing(path)
    FileUtils.mkdir(path) unless File.exists?(path)
  end
  
  
  # Clean Up
  #
  # Cleans up the temporary created files to create our
  # HTML Book.
  #
  def clean_up(*paths)
    paths.each { |path| FileUtils.rm_rf(path) }
  end
  
end