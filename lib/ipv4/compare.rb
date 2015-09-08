# coding: utf-8

class IPv4

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
