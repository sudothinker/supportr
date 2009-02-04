class IncomingMailHandler
  def self.receive(msg, uid)
    Rails.logger.info("Received email: #{uid}")
    Email.create! :message => msg, :uid => uid
  end
end