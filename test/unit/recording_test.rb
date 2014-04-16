require 'test_helper'

class RecordingTest < ActiveSupport::TestCase
   test "recording_count" do
     assert_equal 1, Recording.count
   end



end
