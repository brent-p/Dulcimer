# Brent Parish
# hello@brentparish.com
# http_response.rb

class HttpResponse
  CONTENT_LENGTH_LABEL = "Content-Length: "
  CONNECTION_CLOSE_LABEL = "Connection: close"
  CONTENT_TYPE_LABEL = "Content-Type: "
  CRLF = "\r\n"


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
    return @version + @status + CRLF +
      CONTENT_TYPE_LABEL + @content_type + CRLF +
      CONTENT_LENGTH_LABEL + "#{@content.bytesize}"+ CRLF +
      CONNECTION_CLOSE_LABEL + CRLF + CRLF +
      @content           
  end
end
  
