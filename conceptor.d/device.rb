def device(entry)

  case entry[2]
  when /a(dd)?/
    if entry[5] =~ /r(outer)?/
      $network[entry[3]] = AmazingNetwork::Router.new
    else
      $network[entry[3]] = AmazingNetwork::Device.new
    end
  when /rm|remove|del(ete)?/
    $network.delete entry[3]
  else
    puts "Error: no kind of action '#{entry[2]}'"
    return false
  end

end
