# coding: utf-8
require "test/unit"

require_relative '../lib/device'

class TestDevice < Test::Unit::TestCase

  def test_create
    AmazingNetwork::Device.new()
    AmazingNetwork::Device.new("127.0.0.1/24")
    AmazingNetwork::Device.new(IPv4.new("127.0.0.1/24"))
  end

  def test_interfaces
    o = AmazingNetwork::Device.new("127.0.0.1/32")
    assert_equal(1, o.interfaces.size)
    o.add_interface("10.0.0.1/24")
    assert_equal(2, o.interfaces.size)
    o.rm_interface("10.0.0.1/24")
    assert_equal(1, o.interfaces.size)
  end

  def test_phy_links
    o1 = AmazingNetwork::Device.new("10.0.0.1/24")
    o2 = AmazingNetwork::Device.new("10.0.0.2/24")
    o1.add_phy_link o2
    assert_equal(1, o1.phy_links.size)
    assert_equal(1, o2.phy_links.size)
    o2.rm_phy_link o1
    assert_equal(0, o1.phy_links.size)
    assert_equal(0, o2.phy_links.size)
  end

end
