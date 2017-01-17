# Copyright (c) Brent Parish
# hello@brentparish.com
# Dulcimer, a micro webserver

require 'socket'

def shut_down(server)
  puts "shutting down dulcimer..."
  server.close
end

HOST = ''
PORT = 9999
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
  client = server.accept
  request = client.gets
  puts "request:\n#{request}"

  http_response = "HTTP/1.1 200 OK\n\nHello, World!"
  puts "response:\n#{http_response}"
  client.puts http_response

  client.close
end






