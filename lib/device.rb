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

    # delete an interface of the device
    def rm_interface ip
      @interfaces.delete_if{|i| i.ip.match?(ip)}
    end

    # @param interface_id [Interface, IPv4, String] a valid interface connected to the device
    # @param interface_out [Interface] a valid Interface to connect
    #
    # Add a physical link between 2 interfaces
    # If a link already exists on the interface, it will be erased
    # The interface_out has to be plugged on a device
    def add_phy_link interface_id, interface_out
      interface_in = find_internal_interface(interface_id)
      raise "No such interface" if interface_in.nil?
      @phy_links[interface_in] = interface_out
      interface_out.device.phy_links[interface_out] = interface_in
    end

    # @param interface_id [Interface, IPv4, String] a valid interface connected to the device
    #
    # disconnect interface
    # The interface_out has to be plugged on a device
    def rm_phy_link interface_id
      interface_in = find_internal_interface(interface_id)
      raise "No such interface" if interface_in.nil?
      device = @phy_links[interface_in].device
      @phy_links.delete interface_in
      device.phy_links.delete_if{|k, v| v.ip.match?(interface_in.ip)}
    end

    def add_route network, interface_id
      interface = find_internal_interface(interface_id)
      return false if interface.nil?
      @routes[network] = interface
    end

    def rm_route network
      @routes.delete_if{|net, inter| net.match(network)}
    end

    # @param ip [IPv4, String]
    # @return [Device]
    #
    # If the device has an interface with it's ip equal to the param ip, then self
    # Else, if the device is the emeter (first node), then
    # If the device is connected to an interace having the ip, then the connected device
    # Else, search a route and redirect to or return nil
    # This algorithm take takes of the ttl
    def route_to ip, opt={ttl: 255, is_emet: true}
      # ip = ip.interfaces.first if ip.is_a? Device
      return self if self.has_ip?(ip)
      return nil if not opt[:is_emet] or opt[:ttl] == 0
      phy = @phy_links.values.find{|out| out.ip.match?(ip)}
      return phy.device if phy
      route = find_route_for(ip)
      return nil if not route
      return route[:to].device.route_to(ip, {ttl: opt[:ttl] - 1, is_emet: false})
    end

    # @param ip [IPv4, String]
    # @return [TrueClass, FalseClass]
    #
    # If the device has an interface with it's ip equal to the param ip, then true
    # Else, if the device is the emeter (first node), then
    # If the device is connected to an interace having the ip, then true
    # Else, search a route and redirect to or return false
    # This algorithm take takes of the ttl
    def route! ip, opt={ttl: 255, is_emet: true}
      return route_to(ip, opt) != nil
    end

    protected
    # find an interface to direct the flux
    def find_route_for(ip)
      interface = @routes.find{|net, int| IPv4(ip).is_on?(net)}
      return nil if interface.nil?
      to = find_connected_interface(interface[1])
      return nil if to.nil?
      return {to: to, from: interface[1], interface: interface[1], net: interface[0]}
    end

    # @param id [String, IPv4, Integer, Interface]
    #   - {Integer}: find in the list of the interfaces the n' element
    #   - {Interface}: use it's ip like if the argument is an IPv4
    #   - {String}, {IPv4}: find an interface having this IPv4
    #
    # Find an interface setup on the current device
    def find_internal_interface(id)
      return interface_in = @interfaces[id] if id.is_a? Integer
      id = id.ip if id.is_a? Interface
      id = IPv4(id) if id.is_a? String
      interface_in = @interfaces.find{|i| i.ip.match?(id)}
    end

    def find_connected_interface(from_interface)
      from_interface = find_internal_interface(from_interface)
      found = @phy_links.find{|from, to| from == from_interface}
      return nil if not found
      return found[1]
    end

  end

end
