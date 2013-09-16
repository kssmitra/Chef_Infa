#
# Cookbook Name:: attrtest
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#node2_servers = search(:node, "recipe:attrtest AND demo:#{node.demo}")
#node2_ips = node2_servers.map { |node| node['ipaddress'] }
#node2_ip = node2_ips[0];

#node2_ips.each { |node| puts node } 

puts find_repo_server()
