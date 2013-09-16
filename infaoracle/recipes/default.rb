#
# Cookbook Name:: infaoracle
# Recipe:: default
#
# Copyright 2012, Informatica
#
# All rights reserved - Do Not Redistribute
#

#1. Download the binary to #{oraclehomedir}/cdrom
directory "#{node[:infaoracle][:oraclehomedir]}/cdrom" do
	mode "0755"
        owner node[:infaoracle][:user]
        group node[:infaoracle][:group]
        action :create
        recursive true
end

checksum = get_checksum(node.infaoracle.installer)
reposerver = find_repo_server()
node[:infaoracle][:installer_url]["reposerverhostname"] = reposerver

remote_file "#{node[:infaoracle][:oraclehomedir]}/cdrom/client.zip" do
        source node[:infaoracle][:installer_url]
        mode "0555"
	checksum "#{checksum}"
	not_if { File.exists? ("#{node[:infaoracle][:oraclehomedir]}/cdrom/client.zip") }
end

#2. unzip the installer
script "unzip_oracle_installer" do
	interpreter "bash"
	user node[:infaoracle][:user]
	group node[:infaoracle][:group]
	cwd "#{node[:infaoracle][:oraclehomedir]}/cdrom"
	code <<-EOH
		/usr/bin/unzip #{node[:infaoracle][:oraclehomedir]}/cdrom/client.zip
	EOH
end

#3. Create the response file. 11.2.0.1_client_install.rsp.erb
template "#{node[:infaoracle][:oraclehomedir]}/cdrom/client/client_install.rsp" do
        source "#{node[:infaoracle][:version]}_client_install.rsp.erb" 
	owner node[:infaoracle][:user]	
	group node[:infaoracle][:group]
	mode "0644"
end


#4. Create oraInventory and orahome.
directory node[:infaoracle][:orainventory] do
	mode "0775"
        owner node[:infaoracle][:user]
        group node[:infaoracle][:group]
        action :create
        recursive true
        not_if { File.exists? ("#{node[:infaoracle][:orainventory]}") }
end
	
directory node[:infaoracle][:product] do
	mode "0755"
        owner node[:infaoracle][:user]
        group node[:infaoracle][:group]
        action :create
        recursive true
        not_if { File.exists? ("#{node[:infaoracle][:product]}") }
end

execute "/bin/chown #{node[:infaoracle][:user]}:#{node[:infaoracle][:group]} #{node[:infaoracle][:oraclehomedir]}/product" do
end

#5. Run the Silent installer.
#script "run_oracle_silent_isntaller" do
#	interpreter "bash"
#	user node[:infaoracle][:user]
#	group node[:infaoracle][:group]
#        cwd "#{node[:infaoracle][:oraclehomedir]}/cdrom/client"
#	code <<-EOH
#		#{node[:infaoracle][:oraclehomedir]}/cdrom/client/runInstaller -silent -responseFile #{node[:infaoracle][:oraclehomedir]}/cdrom/client/client_install.rsp 
#	EOH
#end
execute "add_oracle_to_sudoers" do
	command "echo #{node[:infaoracle][:user]} ALL=\\(ALL\\)      NOPASSWD: ALL >> /etc/sudoers"
	not_if  "grep #{node[:infaoracle][:user]} /etc/sudoers" 
end 

execute "run_oracle_silent_isntaller" do
	command  "sudo -u #{node[:infaoracle][:user]}  #{node[:infaoracle][:oraclehomedir]}/cdrom/client/runInstaller -silent -responseFile #{node[:infaoracle][:oraclehomedir]}/cdrom/client/client_install.rsp" 
	cwd "#{node[:infaoracle][:oraclehomedir]}/cdrom/client"
	user node[:infaoracle][:user]
	group node[:infaoracle][:group]
	action :run
end

execute "delete_oracle_from_sudoers" do
	command "/bin/sed -i '/^#{node[:infaoracle][:user]}'/d  /etc/sudoers"
	only_if " grep #{node[:infaoracle][:user]} /etc/sudoers "
end 

