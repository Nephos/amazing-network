require_relative 'ipv4'

module AmazingNetwork

  class Device

    attr_accessor :default_gw, :interfaces, :phy_links, :routes

    def initialize(*interfaces)
      @interfaces = interfaces.map{|ip| IPv4(ip)}
      @phy_links = []
      @routes = {}
      # @default_gw = IPv4(default_gw) if default_gw
    end

    def has_ip? ip
      ip = IPv4(ip)
      @interfaces.find{|i| i == ip}
    end

    def add_interface ip
      ip = IPv4(ip)
      @interfaces << ip
    end

    def rm_interface ip
      ip = IPv4(ip)
      @interfaces.delete ip
    end

    def add_phy_link obj
      @phy_links << obj
      obj.phy_links << self
    end

    def rm_phy_link obj
      @phy_links.delete obj
      obj.phy_links.delete self
    end

    def add_route network, obj
      return false if obj.nil?
      @routes[network] = obj
    end

    def rm_route network
      @routes.delete network
    end

    def route! ip
      return self.has_ip?(ip)
    end

  end

end
