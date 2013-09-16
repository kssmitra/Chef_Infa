#
# Cookbook Name:: ics
# Recipe:: node4
#
# Copyright 2012, Informatica Corp.
# Author: Mitra Kaseebhotla
#
# All rights reserved - Do Not Redistribute
#

# 1. Mount the /opsshare, /appshare and /pcshare from node1, node2 and node3 respectively.


#node1 = search(:node, "recipe:ics\\:\\:node1")
#node1_ip = #{node1['ipaddress']}
#
#node2 = search(:node, "recipe:ics\\:\\:node2")
#node2_ip = #{node2['ipaddress']}
#
#node3 = search(:node, "recipe:ics\\:\\:node3")
#node3_ip = #{node3['ipaddress']}

package "rpcbind" do
	action :install
end

service "rpcbind" do
        action [:enable, :start]
end


node1_servers = search(:node, "recipe:ics\\:\\:node1")
node1_ips = node1_servers.map { |node| node['ipaddress'] }
node1_ip = node1_ips[0];

node2_servers = search(:node, "recipe:ics\\:\\:node2")
node2_ips = node2_servers.map { |node| node['ipaddress'] }
node2_ip = node2_ips[0];

node3_servers = search(:node, "recipe:ics\\:\\:node3")
node3_ips = node3_servers.map { |node| node['ipaddress'] }
node3_ip = node3_ips[0];

if node1_ip
	execute "mkdir -p /opsshare" do
	not_if " mount | grep /opsshare "
	end

	mount "/opsshare" do
       	 mount_point "/opsshare"
       	 device "#{node1_ip}:/opsshare"
       	 fstype "nfs"
         options "rw,soft"
       	 action [:mount ,:enable]
         only_if  " /usr/sbin/showmount -e #{node1_ip}  | /bin/grep #{node['ipaddress']} "
#         not_if " /bin/mount | /bin/grep /opsshare "
	end
end

if node2_ip
	execute "mkdir -p /appshare" do
	not_if " mount | grep /appshare "
	end

	mount "/appshare" do
       	 mount_point "/appshare"
       	 device "#{node2_ip}:/appshare"
       	 fstype "nfs"
         options "rw,soft"
       	 action [:mount ,:enable]
         only_if  " /usr/sbin/showmount -e #{node2_ip}  | /bin/grep #{node['ipaddress']} "
#         not_if " /bin/mount | /bin/grep /appshare "
	end
end

if node3_ip
	execute "mkdir -p /pcshare" do
	not_if " mount | grep /pcshare "
	end

	mount "/pcshare" do
       	 mount_point "/pcshare"
       	 device "#{node3_ip}:/pcshare"
       	 fstype "nfs"
         options "rw,soft"
       	 action [:mount ,:enable]
         only_if  " /usr/sbin/showmount -e #{node3_ip}  | /bin/grep #{node['ipaddress']} "
#         not_if " /bin/mount | /bin/grep /pcshare "
	end
end

#4. Get the mysql db server node and add it as the entry to /etc/hosts file
mysqlnode_servers = search(:node, "recipe:icsmysql\\:\\:server")
mysqlnode_ips = mysqlnode_servers.map { |node| node['ipaddress'] }
mysqlnode_hostnames = mysqlnode_servers.map { |node| node['hostname'] }
mysqlnode_ip = mysqlnode_ips[0]
mysqlnode_hostname = mysqlnode_hostnames[0]

execute "echo #{mysqlnode_ip}   #{mysqlnode_hostname}   \\# MySQL server >> /etc/hosts" do
        not_if " grep #{mysqlnode_ip} /etc/hosts "
end

