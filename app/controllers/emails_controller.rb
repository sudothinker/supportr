class EmailsController < ApplicationController
  def index
    @emails = Email.all
  end
  
  def archive
    @emails = Email::Archive.all
  end
end