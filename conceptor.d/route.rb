def route(entry)

  case entry[2]
  when /a(dd)?/
    $network[entry[3]].add_route *(entry[5].split[0..1])
  when /rm|remove|del(ete)?/
    $network[entry[3]].rm_route entry[5]
  else
    puts "Error: no kind of action '#{entry[2]}'"
    return false
  end

end
