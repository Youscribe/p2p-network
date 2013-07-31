servers = node['p2p-network']['servers']

unless Chef::Config[:solo]
  case node['p2p-network']['search_by']
  when "recipe"
    query = 'recipes:p2p-network'
  when "role"
    if node['p2p-network']['role']
      query = "roles:#{node['p2p-network']['role']}"
    else
      return "no role provided"
    end
  else
    return "bad value for node['tunnel']['search_by']"
  end
  query += " AND chef_environment:#{node.chef_environment}" if node['p2p-network']['restrict_environment']
  query += " NOT fqdn:#{node["fqdn"]}"
  Chef::Log.debug("p2p-network searching for '#{query}'")
  servers += search(:node, query) || []
end

if servers.empty?
  Chef::Log.info "Neither server found"
  return
end

ruby_block "Cleanup interfaces" do
  block do
    node.set['p2p-network']['interfaces'].clear
  end
end

servers.each do | server |
  unless server['p2p-network']['external']['ipaddress']
    Chef::Log.info("Server #{server["hostname"]} can't be added in p2p-network")
    Chef::Log.info("Lack of information in node")
    next
  end

  interface =  interface_name(server["hostname"])

  tunnel_ipip server["hostname"] do
    tunnel_name interface
    host server["hostname"]
    remote server['p2p-network']['external']['ipaddress']
    local node['p2p-network']['external']['ipaddress'] if node['p2p-network']['external']['ipaddress']
    interface node['p2p-network']['external']['interface'] if node['p2p-network']['external']['interface']
  end

  ruby_block "Register tunnel #{interface}" do
    block do
      interfaces = [ interface ] + node['p2p-network']['interfaces'].to_a
      node.set['p2p-network']['interfaces'] = interfaces.sort.uniq
    end
  end

#  ifconfig "up tun_#{server["hostname"]}" do
#    device "tun_#{server["hostname"]}"
#    target node['p2p-network']['internal']['ipaddress']
#    action :enable
#    only_if {  node['p2p-network']['internal']['ipaddress'] }
#  end
  
  execute "add ip to #{interface}" do
    command "ip addr add #{node['p2p-network']['internal']['ipaddress']} dev #{interface}"
    returns [0,2] # ip can be already here
    only_if {  node['p2p-network']['internal']['ipaddress'] }
  end

  execute "up #{interface}" do
    command "ip link set dev #{interface} up"
    not_if "ip link show #{interface} | grep -q UP"
  end

  route server['p2p-network']['internal']['ipaddress'] do
    device interface
    only_if { server['p2p-network']['internal']['ipaddress'] }
  end

  route server['p2p-network']['internal']['network'] do
    device interface
    only_if { server['p2p-network']['internal']['network'] }
  end
end

ruby_block "Save changes to node" do
  block do
    node.save
  end
end
