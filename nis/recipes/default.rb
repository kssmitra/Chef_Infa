#
# Cookbook Name:: nis
# Recipe:: default
#
# Copyright 2012, Informatica Corp.
# Author : Mitra Kaseebhotla
#
# All rights reserved - Do Not Redistribute
#

# 1. Install the ypbind package
package "ypbind" do
	action :install
end

# 2. Set domain name
script "set_domain_name" do
	interpreter "bash"
	user "root"
	cwd "/etc"
	code <<-EOH
		cp -p /etc/sysconfig/network /etc/sysconfig/network.$(date +%F_%T)
		echo "NISDOMAIN=infa" >> /etc/sysconfig/network
	EOH
	not_if " grep NISDOMAIN=infa /etc/sysconfig/network "
end

# 3. Start the nis client daemons 
service node[:nis][:service] do
  	supports :status => true, :restart => true
  	action  :enable
end

# 4. Set the domainname and the ypservers
template "/etc/yp.conf" do
	source "yp.conf.erb"
	owner "root"
	group "root"
	mode "0644"
  	notifies :restart, resources(:service => node[:nis][:service])
end

# 5. Change the /etc/nsswitch.conf to make the server look for NIS maps 
template "/etc/nsswitch.conf" do
	source "nssswitch.conf.erb"
	owner "root"
	group "root"
	mode "0644"
end

# 6. Install the autofs packages (usually it is there. in case if it is missed in the server install)
package "autofs" do
        action :install
end

# 7. Restart the autofs service
service node[:autofs][:service] do
        supports :status => true, :restart => true
        action  :enable
end

# 8. Change the /etc/auto.master to make +auto_master entry.
template "/etc/auto.master" do
        source "auto.master.erb"
        owner "root"
        group "root"
        mode "0644"
	notifies :restart, resources(:service => node[:autofs][:service])
end

# 9. Create Softlinks under / pointing to /nfs

node[:autofs][:links].each_pair do |linkname,linkedto|
	link "#{linkname}" do
		to "#{linkedto}"
	end
end
	
