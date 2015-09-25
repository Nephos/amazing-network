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
    def route! ip, opt={ttl: 255, is_emet: true}
      # ip = ip.interfaces.first if ip.is_a? Device
      return true if self.has_ip?(ip)
      return false if opt[:ttl] == 0
      phy = @phy_links.values.find{|out| out.ip.match?(ip)}
      return true if phy
      route = find_route_for(ip)
      return false if not route
      return route[:to].device.route!(ip, {ttl: opt[:ttl] - 1, is_emet: false})
    end

  end

end
