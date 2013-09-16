#
# Cookbook Name:: nb
# Recipe:: default
#
# Copyright 2012, Informatica Corp.
# Author: Mitra Kaseebhotla
#
# All rights reserved - Do Not Redistribute
#

#script "install_nb_client" do
#	interpreter "bash"
#	user "root"
#	cwd "/usr"
#	code <<-EOH
#		mkdir -p /unixdb
#		mount | grep /unixdb > /dev/null 2>&1 || mount psnfs1:/vol/unixdb	/unixdb
#		cat /unixdb/NB/NB_7.0_CLIENTS_GA/responses | /unixdb/NB/NB_7.0_CLIENTS_GA/install	
#		umount /unixdb
#	EOH
#	not_if { File.exists?("/usr/openv/netbackup/") }
#end

#node[:nb][:mediaservers].each do |mediaserver|
#        execute " echo SERVER = #{mediaserver} >> /usr/openv/netbackup/bp.conf " do
#        not_if " grep #{mediaserver} /usr/openv/netbackup/bp.conf "
#	end 
#end

checksum = get_checksum(node.nb.installer)
reposerver = find_repo_server()
node[:nb][:installer_url]["reposerverhostname"] = reposerver


#1. Get the installer file from repo.
remote_file "/tmp/#{node.nb.installer}" do
	source "#{node.nb.installer_url}"
	mode "0644"
	checksum "#{checksum}"
end

#2. Do the install.
script "install_nb_client" do
	interpreter "bash"
	user "root"
	cwd "/tmp"
	code <<-EOH
		tar xvf /tmp/#{node.nb.installer}
		cat /tmp/#{node.nb.installer_untar}/responses | /tmp/#{node.nb.installer_untar}/install	
	EOH
	not_if { File.exists?("/usr/openv/netbackup/") }
end

template "/usr/openv/netbackup/bp.conf" do
	source "bp.conf.erb"
end

