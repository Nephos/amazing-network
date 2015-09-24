require_relative 'ipv4'
require_relative 'device'

module AmazingNetwork

  class Router < Device

    def route! ip
      ret = super(ip)
      return true if ret
      raise "Not implemented yet"
      # find an network matching with the ip and route to the object
      return obj.route!
    end

  end

end
