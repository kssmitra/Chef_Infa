#
# Cookbook Name:: infajava
# Recipe:: default
#
# Copyright 2012, Informatica Corp.
# Author: Mitra Kaseebhotla
#
# All rights reserved - Do Not Redistribute
#

#1. Get the installer from the repo.
#if node[:kernel][:machine] == "x86_64"
#	cookbook_file	"/tmp/jdk-6u13-linux-x64-rpm.bin" do
#		mode 0755
#	end
#else
#	cookbook_file	"/tmp/jdk-6u13-linux-i586-rpm.bin" do
#		mode 0755
#	end
#end

#1. Get the installer from the repo.
checksum = get_checksum(node.java.installer)
reposerver = find_repo_server()
node[:java][:installer_url]["reposerverhostname"] = reposerver
remote_file "/tmp/#{node.java.installer}" do
	source "#{node.java.installer_url}"
	mode "0755"
	checksum "#{checksum}"
end

#2. Install java from installer.
location_ver = node[:java][:version].gsub(/(\d+)u(\d+)/,'1.\1.0_\2')
script "install_java" do
	interpreter "bash"
	user "root"
	cwd "/tmp"
	code <<-EOH
		/tmp/#{node.java.installer}
	EOH
	not_if { File.exists?("/usr/java/jdk#{location_ver}/") } 
end

