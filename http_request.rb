# Brent Parish
# hello@brentparish.com
# http_request.rb

require 'uri'

class HttpRequest
  attr_accessor :action, :path, :version, :type

  def initialize(request_str)
    parse(request_str)
  end

  def parse(request_str)
    puts "parse"
    request = request_str.split(" ")
    @action = request[0]
    @path = clean_path(request[1])
    @version = request[2]
    @type = File.extname(@path).gsub(".", "")
  end

  def clean_path(request_uri)
    puts "clean_path"
    path = URI.unescape(URI(request_uri).path)

    puts "unclean #{path}"
    #From http://practicingruby.com/articles/implementing-an-http-file-server
    #Stop server from serving files from outside the www folder
    clean = []

    # Split the path into components
    parts = path.split("/")

    parts.each do |part|
      # skip any empty or current directory (".") path components
      next if part.empty? || part == '.'
      # If the path component goes up one directory level (".."),
      # remove the last clean component.
      # Otherwise, add the component to the Array of clean components
      part == '..' ? clean.pop : clean << part
    end

    puts "Clean path: #{clean}"
    return clean.join("")
  end
  
end
