module EmailsHelper
  def display_email(email)
    render :partial => 'emails/email', :locals => {:email => TMail::Mail.parse(email.message)}
  end
end