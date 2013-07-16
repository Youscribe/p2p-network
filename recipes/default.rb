unless Chef::Config[:solo]
  case node['p2p-network']['search_by']
  when "recipe"
    query = 'recipes:p2p-network'
  when "role"
    if node['p2p-network']['role']
      query = "role:#{node['p2p-network']['role']}"
    else
      return "no role provided"
    end
  else
    return "bad value for node['tunnel']['search_by']"
  end
  query += " AND chef_environment:#{node.chef_environment}" if node['tunnel']['restrict_environment']
  Chef::Log.debug("p2p-network searching for '#{query}'")
  servers += search(:node, query)
end

servers.each do | server |
  unless server['p2p-network']['ipaddress']
    Chef::Log.info("Server #{server["hostname"]} can't be added in p2p-network")
    Chef::Log.info("Lack of information in node")
    next
  end

  tunnel_ipip server["hostname"] do
    remote server['p2p-network']['ipaddress']
    local node['p2p-network']['ipaddress']
    interface node['p2p-network']['interface'] if node['p2p-network']['interface']
  end
end
