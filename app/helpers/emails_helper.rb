module EmailsHelper
  def display_email(email)
    render :partial => 'emails/email', :locals => {:email => TMail::Mail.parse(email.message)}
  end
  
  def body_from_tmail(tmail)
    result = nil
    if tmail.multipart?
      tmail.parts.each do |part|
        result = part.unquoted_body if part.content_type =~ /plain/i
      end
    else
      result = tmail.unquoted_body
    end
    result
  end
end