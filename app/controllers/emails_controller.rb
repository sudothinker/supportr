class EmailsController < ApplicationController
  def index
    @emails = Email.all
  end
  
  def archive
    @emails = Email::Archive.all
  end
  
  def update
    @email = Email.find params[:id]
    if @email.update_attributes params[:email]
      redirect_to emails_path
    end
  end
end