# Brent Parish
# hello@brentparish.com
# dulcimer.rb
# Dulcimer, a micro webserver

require 'socket'
require_relative 'http_response'
require_relative 'http_request'

HOST = ''
PORT = 9999
WEB_ROOT = "./www"
CONTENT_TYPE = {
    "html" => HttpResponse::HTTP_TYPE_HTML,
    "txt" => HttpResponse::HTTP_TYPE_PLAIN,
    "jpg" => HttpResponse::HTTP_TYPE_JPG,
    "jpeg" => HttpResponse::HTTP_TYPE_JPG,
    "png" => HttpResponse::HTTP_TYPE_PNG,
    "ico" => HttpResponse::HTTP_TYPE_ICO
}


def shut_down(server)
  puts "shutting down dulcimer..."
  server.close
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

loop do
  request_socket = server.accept

  http_request = HttpRequest.new(request_socket.gets)
  puts http_request.action
  puts http_request.path
  puts http_request.version

  path = File.join(WEB_ROOT, http_request.path)

  content = ""
  status = ""
  type = ""
  if File.exist?(path) && !File.directory?(path)
    File.open(path,"rb") do |file|
      status = HttpResponse::HTTP_STATUS_200
      type = CONTENT_TYPE[http_request.type.downcase]
      puts "type #{type}"
      content = file.read
    end
  else
    status = HttpResponse::HTTP_STATUS_404
    type = HttpResponse::HTTP_TYPE_PLAIN
    content = "404 File not found"
  end

  puts "path #{path}"
  puts "file_path: #{http_request.path}"
  puts "WEB root: #{WEB_ROOT}"

  http_response = HttpResponse.new(
    HttpResponse::HTTP_VERSION_1_1,
    status,
    type,
    content)

  request_socket.print http_response.build_response
  request_socket.close
  
end









