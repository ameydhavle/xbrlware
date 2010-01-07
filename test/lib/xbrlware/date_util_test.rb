require File.dirname(__FILE__) + '/../../test_helper.rb'
class TestDateUtil < Test::Unit::TestCase
  def test_stringify_date
    dt=Date.parse("2009-12-15")
    dt_str=Xbrlware::DateUtil.stringify_date(dt)
    assert_equal("Dec 15, 2009", dt_str)
  end

  def test_stringify_date_with_nil
    dt_str=Xbrlware::DateUtil.stringify_date(nil)
    assert_equal("", dt_str)
  end

  def test_months_between
    start_dt=Date.parse("2009-09-15")
    end_dt=Date.parse("2009-12-15")

    months=Xbrlware::DateUtil.months_between(start_dt, end_dt)
    assert_equal(3, months)

    months=Xbrlware::DateUtil.months_between(end_dt, start_dt)
    assert_equal(3, months)
  end
end