require_relative 'ipv4'

module AmazingNetwork

  class Device

    attr_accessor :default_gw, :interfaces, :phy_links, :routes

    def initialize(*interfaces)
      @interfaces = interfaces.map{|ip| Interface.new(self, ip)}
      @phy_links = {}
      @routes = {}
      # @default_gw = IPv4(default_gw) if default_gw
    end

    def has_ip? ip
      @interfaces.find{|i| i.ip.match?(IPv4(ip)) }
    end

    def add_interface ip
      interface = Interface.new(self, ip)
      @interfaces << interface
      @interfaces.uniq!
    end

    def rm_interface ip
      @interfaces.delete_if{|i| i.ip.match?(ip)}
    end

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

    def route! ip
      return true if self.has_ip?(ip)
      phy = @phy_links.find{|phy| phy.ip.match(ip)}
      return phy.route! if phy
      return false
    end

  end

end
