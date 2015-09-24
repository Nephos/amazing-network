require_relative 'ipv4'

# def Interface(device, ip)
#   Interface.new(device, ip)
# end

module AmazingNetwork

  class Interface

    attr_accessor :device
    attr_accessor :ip

    def initialize(device, ip)
      @device = device
      @ip = IPv4(ip)
    end

  end

end
