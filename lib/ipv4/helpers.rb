# coding: utf-8

def IPv4(obj)
  return IPv4.new(obj) if obj.is_a? String
  return obj
end

class IPv4

  MAX_SPACE = "255.255.255.255"
  MAX_SPACE_MASK = "/32"
  def self.max_spaced(ip, opt={mask: false, fixed: :post, char: ' '})
    opt[:char] ||= ' '
    opt[:mask] ||= false
    opt[:fixed] ||= :post
    size_add = MAX_SPACE.size - ip.size
    size_add += MAX_SPACE_MASK.size if opt[:mask]
    case opt[:fixed]
    when :post
      ip + opt[:char]*size_add
    when :pre,:prefix
      opt[:char]*size_add + ip
    else
      ip + opt[:char]*size_add
    end
  end

  def to_s(type=:long)
    case type
    when :long
      str = "ip: " + IPv4.max_spaced(@frag.join(".") + "/" + @mask.to_s, mask: true)
      str += " net: " + IPv4.max_spaced(@net.join("."))
      str += " broad: " + IPv4.max_spaced(@broad.join("."))
    when :full
      str = @frag.join(".") + "/" + @mask.to_s
    when :short
      str = @frag.join(".")
    else
      str = to_s(:short)
    end
    str
  end

end
