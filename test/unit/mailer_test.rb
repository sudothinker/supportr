require 'test_helper'

class MailerTest < ActionMailer::TestCase
  test "reply" do
    @expected.subject = 'Mailer#reply'
    @expected.body    = read_fixture('reply')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Mailer.create_reply(@expected.date).encoded
  end

end
