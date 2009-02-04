require 'test/unit'
require File.join(File.dirname(__FILE__), 'fixtures/video')

class IsArchivedTest < Test::Unit::TestCase
  fixtures :videos

  def test_archiving_removes_from_table
    v = videos(:how_to_dance)
  end
end
