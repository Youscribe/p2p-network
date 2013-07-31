servers = node['p2p-network']['servers']

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
  servers += search(:node, query) || []
end

unless servers
  Chef::Log.info "Neither server found"
  return
end

servers.each do | server |
  unless server['p2p-network']['external']['ipaddress']
    Chef::Log.info("Server #{server["hostname"]} can't be added in p2p-network")
    Chef::Log.info("Lack of information in node")
    next
  end

  tunnel_ipip server["hostname"] do
    remote server['p2p-network']['external']['ipaddress']
    local node['p2p-network']['external']['ipaddress'] if node['p2p-network']['external']['ipaddress']
    interface node['p2p-network']['external']['interface'] if node['p2p-network']['external']['interface']
  end

#  ifconfig "up tun_#{server["hostname"]}" do
#    device "tun_#{server["hostname"]}"
#    target node['p2p-network']['internal']['ipaddress']
#    action :enable
#    only_if {  node['p2p-network']['internal']['ipaddress'] }
#  end
  
  execute "add ip to tun_#{server["hostname"]}" do
    command "ip addr add #{node['p2p-network']['internal']['ipaddress']} dev tun_#{server["hostname"]}"
    returns [0,2] # ip can be already here
    only_if {  node['p2p-network']['internal']['ipaddress'] }
  end

  execute "up tun_#{server["hostname"]}" do
    command "ip link set dev tun_#{server["hostname"]} up"
    not_if "ip link show tun_test | grep -q UP"
  end

  route server['p2p-network']['internal']['ipaddress'] do
    device "tun_#{server["hostname"]}"
    only_if { server['p2p-network']['internal']['ipaddress'] }
  end

  route server['p2p-network']['internal']['network'] do
    device "tun_#{server["hostname"]}"
    only_if { server['p2p-network']['internal']['network'] }
  end
end
