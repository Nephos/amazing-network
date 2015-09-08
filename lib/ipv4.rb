# coding: utf-8

require_relative 'ipv4/helpers'
require_relative 'ipv4/compare'

class IPv4

  attr_reader :frag, :mask, :net, :broad
  def initialize(ip)
    match = ip.match(/^(\d+)\.(\d+)\.(\d+)\.(\d+)\/?(\d+)?$/)
    raise "Invalid ip \"#{ip}\"" if match.nil?
    @frag = match[1..-2].map(&:to_i)
    raise "Invalid ip" if @frag.find{|e| e < 0 or e > 255}
    @mask = (match[-1] || 32).to_i
    calc_net!
    calc_broad!
  end

  def mask_ip
    ip = ((0xFFFFFFFF >> (32-@mask)) << (32-@mask))
    [
      (ip >> (8*3)) % 256,
      (ip >> (8*2)) % 256,
      (ip >> (8*1)) % 256,
      (ip >> (8*0)) % 256,
    ]
  end

  def calc_net!
    mask_ip = mask_ip()
    @net = []
    @frag.each_with_index do |f, i|
      mask_ip_current = f & mask_ip[i]
      @net << mask_ip_current
    end
  end

  def calc_broad!
    mask_ip = mask_ip()
    @broad = []
    @frag.each_with_index do |f, i|
      mask_ip_current = f & mask_ip[i]
      broad_current = mask_ip_current + 256 - (~mask_ip[i]).abs
      @broad << broad_current
    end
  end

  def can_reach? ip
    return is_between? ip.net, ip.broad
  end

  def is_between? ip1, ip2
    ip1 = ip1.join(".") if ip1.is_a? Array
    ip2 = ip2.join(".") if ip2.is_a? Array
    ip1 = IPv4.new ip1 if ip1.is_a? String
    ip2 = IPv4.new ip2 if ip2.is_a? String
    return ((is_lower? ip2 or is_eql? ip2) and (is_upper? ip1 or is_eql? ip1))
  end

  def is_lower? ip
    ip = ip.join(".") if ip.is_a? Array
    ip = IPv4.new ip if ip.is_a? String
    ip.frag.each_with_index do |f, i|
      return false if @frag[i] > f
    end
    return @frag[3] < ip.frag[3]
  end

  def is_upper? ip
    ip = ip.join(".") if ip.is_a? Array
    ip = IPv4.new ip if ip.is_a? String
    ip.frag.each_with_index do |f, i|
      return false if @frag[i] < f
    end
    return @frag[3] > ip.frag[3]
  end

  def is_eql? ip
    ip = ip.join(".") if ip.is_a? Array
    ip = IPv4.new ip if ip.is_a? String
    ip.frag.each_with_index do |f, i|
      return false if @frag[i] != f
    end
    return true
  end

end
