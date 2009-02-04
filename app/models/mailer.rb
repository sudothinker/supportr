class Mailer < ActionMailer::Base
  def reply(email)
    subject       "Re: #{email.parsed.subject}"
    recipients    email.parsed.from
    sent_on       Time.now
    content_type  'text/html'
    body          :msg => email.response.body, :time => email.created_at, :from => "#{email.parsed.friendly_from} <#{email.parsed.from}>",
                  :original => email.body
  end

end
