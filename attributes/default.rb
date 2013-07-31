default['p2p-network']['restrict_environment']  = true
default['p2p-network']['search_by']             = "recipe"
default['p2p-network']['role']                  = "p2p-network"

default['p2p-network']['external']['ipaddress'] = node['ipaddress']

default['p2p-network']['internal']['ipaddress'] = nil

default['p2p-network']['servers']               = []
#                                              = [ {"hostname" => "test1", "p2p-network" => { "ipaddress" => "192.168.0.1"} } ]
