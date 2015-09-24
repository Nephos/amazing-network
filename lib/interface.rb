require_relative 'ipv4'

module AmazingNetwork

  # An Interface is an object, associated to a {Device}. It has ONE IPv4.
  class Interface

    attr_accessor :device
    attr_accessor :ip

    def initialize(device, ip)
      @device = device
      @ip = IPv4(ip)
    end

  end

end
