class EmailsController < ApplicationController
  def index
    @emails = Email.all
  end
  
end