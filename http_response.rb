# Brent Parish
# hello@brentparish.com
# http_response.rb

class HttpResponse
  HTTP_VERSION_1_1 = "HTTP/1.1 "
  HTTP_STATUS_200 = "200 OK"
  HTTP_STATUS_404 = "404 NOT FOUND"
  HTTP_STATUS_500 = "500 Internal Server Error"
  HTTP_TYPE_HTML = "text/html"
  HTTP_TYPE_PLAIN = "text/plain"
  HTTP_TYPE_JPG   = "image/jpeg"
  HTTP_TYPE_PNG   = "image/png"
  HTTP_TYPE_GIF   = "image/gif"
  HTTP_TYPE_ICO   ="image/x-icon"

  HTTP_CLOSE = "close"
  CONTENT_LENGTH_LABEL = "Content-Length: "
  CONNECTION_LABEL = "Connection: "
  CONTENT_TYPE_LABEL = "Content-Type: "


  attr_accessor :version,
                :status,
                :content_type,
                :content_length,
                :content
  
  def initialize(version, status, type, content)
    @version = version
    @status = status
    @content_type = type    
    @content = content
  end

  def build_response    
    return HTTP_VERSION_1_1 + @status + "\r\n" +
           CONTENT_TYPE_LABEL + @content_type + "\r\n" +
           CONTENT_LENGTH_LABEL + "#{@content.bytesize}"+ "\r\n" +
           CONNECTION_LABEL + HTTP_CLOSE + "\r\n\r\n" +
           @content           
  end
end
  
