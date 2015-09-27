module AmazingNetwork

  class Ping

    attr_reader :status
    attr_reader :status_code
    attr_reader :message

    attr_accessor :from, :to, :ttl
    # @param from [Device]
    # @param to [Ip]
    # @param ttl [Integer]
    def initialize(from, to, ttl=255)
      @from = from
      @to = to
      @ttl = -1
      @ttl_init = ttl
    end

    def try
      @ttl = @ttl_init
      @status_code = -1
      @status = false
      @message = ""

      route = @from.find_route_for(@to)
      return _fail_to_route_to if route.nil?

      front = @from.route_to(@to, {ttl: @ttl, is_emet: true})
      return _fail_to_reach_to if front.nil?

      back = front.device.route_to(route[:from].ip)
      return _fail_to_reach_back if back.nil?

      @status = true
      @status_code = 0
    end

    protected
    def _fail_to_route_to
      @message = "No route to #{@to}"
      @status = false
      @status_code = 1
    end

    def _fail_to_reach_to
      @message = "Destination host unreachable"
      @status = false
      @status_code = 2
    end

    def _fail_to_reach_back
      @message = "Destination host unreachable"
      @status = false
      @status_code = 3
    end

  end

end
