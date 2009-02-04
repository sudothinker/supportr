module EmailsHelper
  def display_email(email)
    render :partial => "emails/email", :object => email
  end
end