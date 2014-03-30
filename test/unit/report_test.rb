require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test "null account has name" do
    report = Report::NullAccount.new
    assert report.name
  end
end
