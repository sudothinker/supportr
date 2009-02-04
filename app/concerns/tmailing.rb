module Tmailing
  def parsed
    @parsed ||= TMail::Mail.parse(message)
  end
  
  def body
    if parsed.multipart?
      parsed.parts.each do |part|
        return part.unquoted_body if part.content_type =~ /plain/i
      end
    else
      return parsed.unquoted_body
    end
  end
end