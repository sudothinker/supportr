class Email < ActiveRecord::Base
  include Tmailing
  
  is_archived do
    include Tmailing
  end
  
  belongs_to :response
    
  attr_accessor :events, :reply, :forward, :save_forward
  after_save :process_events
  
  def process_events
    return if @events.nil?
    @events.map{ |e| send("#{e}!")}
  end
  
  # Pseudo state changes for email object
  def event=(event)
    events = event.split(",")
    @events = @events.nil? ? events : @events + events
    @events.flatten!
  end
  
  alias_method :events=, :event=
  
  def reply!
    Mailer.deliver_reply(self)
    archive!
  end
  
  def forward!
    Forward.create! :email => forward if save_forward
    Mailer.deliver_forward(self)
    archive!
  end
end
