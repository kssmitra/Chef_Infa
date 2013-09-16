#
# Cookbook Name:: infa_lx_c2c_mysql
# Recipe:: default
#
# Copyright 2013, Mitra Kaseebhotla
#
# All rights reserved - Do Not Redistribute
#

## 1. Get the rpms from the repo location to /tmp

reposerver = find_repo_server()
node[:infa_lx_c2c_mysql][:server_installer_url]["reposerverhostname"] = reposerver
node[:infa_lx_c2c_mysql][:client_installer_url]["reposerverhostname"] = reposerver

s_checksum = get_checksum(node.infa_lx_c2c_mysql.server)
remote_file "/tmp/#{node.infa_lx_c2c_mysql.server}" do
        source "#{node.infa_lx_c2c_mysql.server_installer_url}"
        mode "0755"
        checksum "#{s_checksum}"
end

c_checksum = get_checksum(node.infa_lx_c2c_mysql.client)
remote_file "/tmp/#{node.infa_lx_c2c_mysql.client}" do
        source "#{node.infa_lx_c2c_mysql.client_installer_url}"
        mode "0755"
        checksum "#{s_checksum}"
end

## 2. Install the rpms 
#
#script "install_perl_dbd" do
#	interpreter "bash"
#	user "root"
#	cwd "/tmp"
#	code <<-EOH
#		/usr/bin/perl -MCPAN -e 'install Bundle::DBI' 
#	EOH
#end
#

script "install_rpms" do
	interpreter "bash"
	user "root"
	cwd "/tmp"
	code <<-EOH
		/bin/rpm -i --nodeps --force /tmp/#{node.infa_lx_c2c_mysql.server}	
		/bin/rpm -i --nodeps --force /tmp/#{node.infa_lx_c2c_mysql.client}	
	EOH

end


##server_package = node[:infa_lx_c2c_mysql][:server].gsub(/\.rpm$/,'')
###server_package[".rpm"] = ""
#rpm_package	"#{server_package}" do
#	source "/tmp/#{node.infa_lx_c2c_mysql.server}"
#	options "--nodeps"
#	action :install
#end
#
#client_package = node[:infa_lx_c2c_mysql][:client]
#client_package[".rpm"] = ""
#package	"#{client_package}" do
#	source "/tmp/#{node.infa_lx_c2c_mysql.client}"
#	options "--nodeps"
#	action :install
#end
#
#
### 3. Configure the mysql 
#
#script "set_mysql_root" do
#	interpreter "bash"
#	user "root"
#	cwd "/root"
#	code <<-EOH
#		/sbin/chkconfig mysql on
#		/sbin/service	mysql start
#		/usr/bin/mysqladmin -u root password 'password'
#		/usr/bin/mysqladmin -u root -h `/bin/hostname -f` password 'password'
#
#		
#		/usr/bin/mysql -u root -p 'password' -e "CREATE DATABASE metastore; GRANT ALL PRIVILEGES ON metastore.* TO cehdp@localhost IDENTIFIED BY 'cehdp'; GRANT ALL PRIVILEGES ON metastore.* TO cehdp@'%' IDENTIFIED BY 'cehdp';"
#
#	EOH
#
#end
