#
# Cookbook Name:: ics
# Recipe:: node3
#
# Copyright 2012, Informatica Corp.
# Author: Mitra Kaseebhotla
#
# All rights reserved - Do Not Redistribute
#

# 1. Mount the 2nd volume in as the /pcshare
execute "mkdir -p /pcshare" do
not_if " mount | grep /pcshare "
end

mount "/pcshare" do
	mount_point "/pcshare"
       	device "/dev/vg02/datavol"
        fstype node[:ics][:datadir_fs]
        action [:mount ,:enable]
        not_if " /bin/mount | /bin/grep /pcshare "
end


# 2. export the /opsshare to other hosts in the group.
package "nfs-utils" do
        action :install
end

service "rpcbind" do
        action [:enable, :start]
end

service "nfs" do
        supports :reload => true
        action [:enable, :start]
end

ics_servers = search(:node, "recipes:ics")
server_ips = ics_servers.map { |node| node['ipaddress'] }

template "/etc/exports" do
        source "node3_exports.erb"
        owner "root"
        group "root"
        mode "0644"
#        variables( :icsnodes => server_ips )
end

server_ips.each { |server_ip|
        if server_ip
#                execute "echo /pcshare #{server_ip}\\(rw\\) >> /etc/exports " do
                execute "sed -i '/pcshare/ s/$/#{server_ip}\(rw\) /' /etc/exports "  do
                notifies :reload, resources(:service => "nfs" ), :immediately
                not_if " /bin/grep #{server_ip} /etc/exports "
                end
        end
}

# 3. Find node1 and node2 and mount other shares from there.
#node1 = search(:node, "recipe:ics\\:\\:node1")
#node1_ip = #{node1['ipaddress']}

#node2 = search(:node, "recipe:ics\\:\\:node2")
#node2_ip = #{node2['ipaddress']}
node1_servers = search(:node, "recipe:ics\\:\\:node1")
node1_ips = node1_servers.map { |node| node['ipaddress'] }
node1_ip = node1_ips[0];

node2_servers = search(:node, "recipe:ics\\:\\:node2")
node2_ips = node2_servers.map { |node| node['ipaddress'] }
node2_ip = node2_ips[0];


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
#        not_if " /bin/mount | /bin/grep /opsshare "
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


#4. Get the mysql db server node and add it as the entry to /etc/hosts file
mysqlnode_servers = search(:node, "recipe:icsmysql\\:\\:server")
mysqlnode_ips = mysqlnode_servers.map { |node| node['ipaddress'] }
mysqlnode_hostnames = mysqlnode_servers.map { |node| node['hostname'] }
mysqlnode_ip = mysqlnode_ips[0]
mysqlnode_hostname = mysqlnode_hostnames[0]

execute "echo #{mysqlnode_ip}   #{mysqlnode_hostname}   \\# MySQL server >> /etc/hosts" do
        not_if " grep #{mysqlnode_ip} /etc/hosts "
end

