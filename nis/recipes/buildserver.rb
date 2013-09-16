#
# Cookbook Name:: nis
# Recipe:: buildserver
#
# Copyright 2012, Informatica Corp.
# Author: Mitra Kaseebhotla
#
# All rights reserved - Do Not Redistribute
#

# 1. Change the /etc/nsswitch.conf to make the server look for NIS maps 
template "/etc/nsswitch.conf" do
	source "nssswitch.conf.build.erb"
	owner "root"
	group "root"
	mode "0644"
end

# 2. Add the compat entries at the end of /etc/passwd and /etc/group
script "change_etc_passwd_file" do
	interpreter "bash"
	user "root"
	cwd "/etc"
	code <<-EOH
		/bin/cp -p /etc/passwd /etc/passwd.$(date +%F)
		echo "+@sysads::::::" >> /etc/passwd
		echo "+@builders::::::" >> /etc/passwd
	EOH
	not_if " grep + /etc/passwd "
end

# 3. Add the softlinks in / pointing to /nfs/*
node[:autofs][:buildserver][:links].each_pair do |linkname,linkedto|
        link "#{linkname}" do
                to "#{linkedto}"
        end
end

