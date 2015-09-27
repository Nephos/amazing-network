def phy(entry)

  raise "NotImplemented"

  case entry[2]
  when /a(dd)?/
  when /rm|remove|del(ete)?/
  else
    puts "Error: no kind of action '#{entry[2]}'"
    return false
  end

end
