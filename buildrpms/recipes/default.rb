#
# Cookbook Name:: buildrpms
# Recipe:: default
#
# Copyright 2012, Informatica Corp.
# Author: Mitra Kaseebhotla
#
# All rights reserved - Do Not Redistribute
#

# 1. Set-up the repo.
#cookbook_file "/etc/yum.repos.d/informatica.repo" do
#	mode 0644
#end
#
#script "setup_vars" do
#	interpreter "bash"
#	user "root"
#	cwd "/etc/yum"	
#	code <<-EOH
#		/bin/mkdir -p /etc/yum/vars
#		/usr/bin/lsb_release -r | /bin/awk '{ print $2 }' > /etc/yum/vars/releasever
#	EOH
#	not_if { File.exists?("/etc/yum/vars/releasever") }
#end

#1. Set-up the repo.
template "/etc/yum.repos.d/informatica.repo" do
	source "informatica.repo.erb"
	mode "0644"
	variables :releasever => node['lsb']['release'] 
end

# 2. Install the extra rpms.
node[:buildrpms][:list].each { |package|

	package "#{package}" do
        	action :install
	end
}

# 3. Start and Enable the services 
node[:buildservices][:list].each { |service|
	service "#{service}" do
       		supports :status => true, :restart => true
        	action [ :enable, :start ]
	end
}

# 4. Specific configurations
script "configure_script" do
	interpreter "bash"
	user "root"
	cwd "/tmp"
	code <<-EOH
		/bin/mkdir -p /usr/progressive/bin
		/bin/ln -s /usr/bin/make /usr/progressive/bin/make
		/usr/bin/rescan-scsi-bus.sh	
	EOH
	not_if {  File.exists?("/usr/progressive/bin/make") }
end
