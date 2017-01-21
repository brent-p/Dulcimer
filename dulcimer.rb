# Brent Parish
# hello@brentparish.com
# dulcimer.rb
# Dulcimer, a micro webserver

require 'socket'
require_relative 'http_response'
require_relative 'http_request'

HTTP_VERSION_1_1 = "HTTP/1.1 "
HTTP_STATUS_200 = "200 OK"
HTTP_STATUS_404 = "404 NOT FOUND"
HTTP_STATUS_500 = "500 Internal Server Error"
HTTP_TYPE_HTML = "text/html"
HTTP_TYPE_PLAIN = "text/plain"
HTTP_TYPE_JPG = "image/jpeg"
HTTP_TYPE_PNG = "image/png"
HTTP_TYPE_SVG = "image/svg"
HTTP_TYPE_GIF = "image/gif"
HTTP_TYPE_ICO = "image/x-icon"
HTTP_TYPE_CSS = "text/css"
HOST = ''
PORT = 9999
WEB_ROOT = "./www"
CONTENT_TYPE = {
    "html" => HTTP_TYPE_HTML,
    "txt"  => HTTP_TYPE_PLAIN,
    "jpg"  => HTTP_TYPE_JPG,
    "jpeg" => HTTP_TYPE_JPG,
    "png"  => HTTP_TYPE_PNG,
    "svg"  => HTTP_TYPE_SVG,
    "ico"  => HTTP_TYPE_ICO,
    "css"  => HTTP_TYPE_CSS
}
PATH_INDEX = "index.html"


def shut_down(server)
  puts "shutting down dulcimer..."
  server.close
end

def serve_file(path, type)
  if File.exist?(path) && !File.directory?(path)
    File.open(path,"rb") do |file|
      @status = HTTP_STATUS_200
      @type = CONTENT_TYPE[type.downcase]
      unless @type.nil? || @type.empty?        
        puts "type #{@type}"
        @content = file.read
      else
        redirect_not_found
      end
    end
  else
    redirect_not_found
  end
end

def redirect_not_found
    @status = HTTP_STATUS_404
    @type = HTTP_TYPE_PLAIN
    @content = "404 File not found"  
end

server = TCPServer.new PORT

Signal.trap("INT") {
  shut_down(server)
  exit
}

# Trap `Kill `
Signal.trap("TERM") {
  shut_down(server)
  exit
}

puts "dulcimer started, listening on port: #{PORT} ctrl+c to shutdown"

x = 0
loop do
  Thread.start(server.accept) do |request_socket|
    #request_socket = server.accept
    request_str = request_socket.gets
    puts "=== Request ==="
    unless request_str.nil?
      http_request = HttpRequest.new(request_str)
      puts http_request.action
      puts http_request.path
      puts http_request.version


      unless http_request.path.empty?
        path = File.join(WEB_ROOT, http_request.path)
      else
        path = File.join(WEB_ROOT, PATH_INDEX)
        http_request.type = "html"
      end

      @content = ""
      @status = ""
      @type = ""

      serve_file(path,http_request.type)

      puts "=== Response ===="
      puts "status: #{@status}"
      puts "type: #{@type}"
      puts "path #{path}"

      http_response = HttpResponse.new(HTTP_VERSION_1_1,
                                       @status,
                                       @type,
                                       @content)

      request_socket.print http_response.build_response
    end

    request_socket.close
    puts "=== Close ====\r\n\r\n"
  end
end











