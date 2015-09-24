# coding: utf-8
require "test/unit"
# require 'pry'

require_relative '../lib/networks'

class TestNetwork < Test::Unit::TestCase

  def test_interfaces
    assert AmazingNetwork::Interface.new(nil, "127.0.0.1/24")
  end

  def test_create_device
    AmazingNetwork::Device.new()
    AmazingNetwork::Device.new("127.0.0.1/24")
    AmazingNetwork::Device.new(IPv4.new("127.0.0.1/24"))
  end

  def test_interfaces_device
    o = AmazingNetwork::Device.new("127.0.0.1/32")
    assert_equal(1, o.interfaces.size)
    o.add_interface("10.0.0.1/24")
    assert_equal(2, o.interfaces.size)
    o.rm_interface("10.0.0.1/24")
    assert_equal(1, o.interfaces.size)
  end

  def test_phy_links_device
    o1 = AmazingNetwork::Device.new("10.0.0.1/24")
    o2 = AmazingNetwork::Device.new("10.0.0.2/24")

    o1.add_phy_link o1.interfaces.first, o2.interfaces.first
    assert_equal(1, o1.phy_links.size)
    assert_equal(1, o2.phy_links.size)

    o2.rm_phy_link o2.interfaces.first
    assert_equal(0, o1.phy_links.size)
    assert_equal(0, o2.phy_links.size)
  end

  def test_simple_ping_device
    c1 = AmazingNetwork::Device.new("10.0.0.2/24")
    r = AmazingNetwork::Router.new("10.0.0.1/24", "10.0.1.1/24")
    c2 = AmazingNetwork::Device.new("10.0.1.2/24")
    c1.add_phy_link c1.interfaces.first, r.interfaces[0]
    c2.add_phy_link c2.interfaces.first, r.interfaces[1]
    assert c1.route! "10.0.0.1"
    assert c2.route! "10.0.1.1"
  end

end
