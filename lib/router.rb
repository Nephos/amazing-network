require_relative 'ipv4'
require_relative 'device'

module AmazingNetwork

  class Router < Device

    # @param ip [IPv4, String]
    # @return [TrueClass, FalseClass]
    #
    # If the device has an interface with it's ip equal to the param ip, then true
    # Else, if the device is connected to an interace having the ip, then true
    # Else, search a route and redirect to or return false
    # This algorithm take takes of the ttl
    def route_to ip, opt={ttl: 255, is_emet: true}
      # ip = ip.interfaces.first if ip.is_a? Device
      return self if self.has_ip?(ip)
      return nil if opt[:ttl] == 0
      phy = @phy_links.values.find{|out| out.ip.match?(ip)}
      return phy if phy
      route = find_route_for(ip)
      return nil if not route
      return route[:to].device.route_to(ip, {ttl: opt[:ttl] - 1, is_emet: false})
    end

  end

end
