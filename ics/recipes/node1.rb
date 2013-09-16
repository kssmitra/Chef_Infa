#
# Cookbook Name:: ics
# Recipe:: node1
#
# Copyright 2012, Informatica Corp.
# Author: Mitra Kaseebhotla
#
# All rights reserved - Do Not Redistribute
#

# 1. Mount the 2nd volume in as the /opsshare
execute "mkdir -p /opsshare" do
not_if " mount | grep /opsshare "
end

mount "/opsshare" do
	mount_point "/opsshare"
       	device "/dev/vg02/datavol"
        fstype node[:ics][:datadir_fs]
        action [:mount ,:enable]
	not_if " /bin/mount | /bin/grep /opsshare "
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

ics_servers = search(:node, "recipe:ics")
server_ips = ics_servers.map { |node| node['ipaddress'] }

#puts server_ips

template "/etc/exports" do
	source "node1_exports.erb"
	owner "root"
	group "root"
	mode 0644
	not_if " /bin/grep /opsshare /etc/exports "
#	variables( :icsnodes => server_ips )
end

server_ips.each { |server_ip| 
	if server_ip
		#execute "echo /opsshare #{server_ip}\\(rw\\) >> /etc/exports " do
		execute "sed -i '/opsshare/ s/$/#{server_ip}\(rw\) /' /etc/exports "  do
		#	sed -i "/^\\/opsshare/ s/$/ #{server_ip}(rw),/" /etc/exports
		notifies :reload, resources(:service => "nfs" ), :immediately
	        not_if " /bin/grep #{server_ip} /etc/exports "
		end
	end
}

# 3. Find node2 and node3 and mount other shares from there.

#node2 = search(:node, "recipe:ics\\:\\:node2")
#node2_ip = #{node2['ipaddress']}

#puts node2_ip
#node3 = search(:node, "recipe:ics\\:\\:node3")
#node3_ip = #{node3['ipaddress']}

node2_servers = search(:node, "recipe:ics\\:\\:node2")
node2_ips = node2_servers.map { |node| node['ipaddress'] }
node2_ip = node2_ips[0];
puts node2_ip

node3_servers = search(:node, "recipe:ics\\:\\:node3")
node3_ips = node3_servers.map { |node| node['ipaddress'] }
node3_ip = node3_ips[0];
puts node3_ip


if node2_ip
	execute "mkdir -p /appshare" do
	not_if " mount | grep /appshare "
	end

	mount "/appshare" do
       	 mount_point "/appshare"
       	 device "#{node2_ip}:/appshare"
       	 fstype "nfs"
	 options "rw,soft"
       	 action [:mount, :enable]
         only_if  " /usr/sbin/showmount -e #{node2_ip}  | /bin/grep #{node['ipaddress']} "
#     	 not_if " /bin/mount | /bin/grep /appshare "
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
       	 action [:mount, :enable]
         only_if  " /usr/sbin/showmount -e #{node3_ip}  | /bin/grep #{node['ipaddress']} "
#	 not_if " /bin/mount | /bin/grep /pcshare "
	end
end

#4. Get the mysql db server node and add it as the entry to /etc/hosts file 
mysqlnode_servers = search(:node, "recipe:icsmysql\\:\\:server")
mysqlnode_ips = mysqlnode_servers.map { |node| node['ipaddress'] }
mysqlnode_hostnames = mysqlnode_servers.map { |node| node['hostname'] }
mysqlnode_ip = mysqlnode_ips[0]
mysqlnode_hostname = mysqlnode_hostnames[0]

execute "echo #{mysqlnode_ip}	#{mysqlnode_hostname}	\\# MySQL server >> /etc/hosts" do
	not_if " grep #{mysqlnode_ip} /etc/hosts "
end
