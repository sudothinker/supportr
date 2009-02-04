class Email < ActiveRecord::Base
  is_archived
  belongs_to :response
    
  attr_accessor :events
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
  
  def parsed
    @parsed ||= TMail::Mail.parse(message)
  end
  
  def body
    result = nil
    if parsed.multipart?
      parsed.parts.each do |part|
        result = part.unquoted_body if part.content_type =~ /plain/i
      end
    else
      result = parsed.unquoted_body
    end
    result
  end
  
  def reply!
    Mailer.deliver_reply(self)
    archive!
  end
end
