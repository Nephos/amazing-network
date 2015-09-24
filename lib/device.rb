require_relative 'ipv4'

module AmazingNetwork

  # A Device is a generic object on the net.
  # It has {Interface}s (0, 1, or more).
  # It can connect theses interfaces to other interfaces via the phy_links
  # It also has routes to direct it's pings to an interface or an other
  class Device

    attr_accessor :default_gw, :interfaces, :phy_links, :routes

    def initialize(*interfaces)
      @interfaces = interfaces.map{|ip| Interface.new(self, ip)}
      @phy_links = {}
      @routes = {}
      # @default_gw = IPv4(default_gw) if default_gw
    end

    # @param ip [IPv4, String]
    # @return [TrueClass, FalseClass]
    #
    # Check if the device has an interface with the ip
    def has_ip? ip
      @interfaces.find{|i| i.ip.match?(IPv4(ip)) }
    end

    # @param ip [String, IPv4, Interface] it will be converted in Interface if it is not
    #
    # add a new interface to the device
    def add_interface ip
      if not ip.is_a? Interface
        interface = Interface.new(self, ip)
      else
        interface = ip
        interface.device = self
      end
      @interfaces << interface
      @interfaces.uniq!
    end

    # rm an interface of the device
    def rm_interface ip
      @interfaces.delete_if{|i| i.ip.match?(ip)}
    end

    # @param interface_id [Interface, IPv4, String] a valid interface connected to the device
    # @param interface_out [Interface] a valid Interface to connect
    def add_phy_link interface_id, interface_out
      interface_id = interface_id.ip if [Interface].include? interface_id.class
      if [String, IPv4].include? interface_id.class
        interface_in = @interfaces.find{|i| i.ip.match?(interface_id)}
      else
        interface_in = @interfaces[interface_id]
      end
      raise "No such interface" if interface_in.nil?
      @phy_links[interface_in] = interface_out
      interface_out.device.phy_links[interface_out] = interface_in
    end

    # @param interface_id [Interface, IPv4, String] a valid interface connected to the device
    #
    # = disconnect interface
    def rm_phy_link interface_id
      interface_id = interface_id.ip if [Interface].include? interface_id.class
      if [String, IPv4].include? interface_id.class
        interface_in = @interfaces.find{|i| i.ip.match?(interface_id)}
      else
        interface_in = @interfaces[interface_id]
      end
      raise "No such interface" if interface_in.nil?
      device = @phy_links[interface_in].device
      @phy_links.delete interface_in
      device.phy_links.delete_if{|k, v| v.ip.match?(interface_in.ip)}
    end

    def add_route network, obj
      return false if obj.nil?
      @routes[network] = obj
    end

    def rm_route network
      @routes.delete_if{|r| r.match(network)}
    end

    # @param ip [IPv4, String]
    # @return [TrueClass, FalseClass]
    #
    # If the device has an interface with it's ip equal to the param ip, then true
    # Else, if the device is connected to an interace having the ip, then true
    # Else false
    def route! ip
      # ip = ip.interfaces.first if ip.is_a? Device
      return true if self.has_ip?(ip)
      phy = @phy_links.values.find{|out| out.ip.match?(ip)}
      return true if phy
      return false
    end

  end

end
