class IncomingMailHandler
  def self.receive(msg)
    email = TMail::Mail.parse(msg)
    Email.create! :subject => email.subject, :from => "#{email.friendly_from}: #{email.from}", :body => body_html_from_email(email) || email.body
  end
  
  # returs an String with just the html part of the body
  # or nil if there is not any html part
  #
  def self.body_html_from_email(email)
     result = nil
     if email.multipart?
       email.parts.each do |part|
         if part.multipart?
           part.parts.each do |part2|
             result = part2.unquoted_body if part2.content_type =~ /html/i
           end
         elsif !email.attachment?(part)
           result = part.unquoted_body if part.content_type =~ /html/i
         end
       end
     else
       result = email.unquoted_body if email.content_type =~ /html/i
     end
     result
   end
end