#
# Cookbook Name:: icsmysql
# Recipe:: server
#
# Copyright 2012, Informatica Corp.
# Author: Mitra Kaseebhotla 
#
# All rights reserved - Do Not Redistribute
#

include_recipe "icsmysql::client"


#1. Create volume and mount it as /export/home

d = node['icsmysql']['external_device']

    if File.exists? ("/dev/#{d}")

        execute "pvcreate -f /dev/#{d}" do
        not_if " /sbin/pvs | /bin/grep /dev/#{d} "
        end
        execute "vgcreate vgdata /dev/#{d}" do
        not_if " /sbin/vgs | /bin/grep vgdata "
        end
        execute "lvcreate -l 100%FREE -n datavol vgdata" do
        not_if " /sbin/lvs | /bin/grep vgdata | /bin/grep datavol "
        end
        execute "mkfs.#{node.icsmysql.datadir_fs} /dev/vgdata/datavol" do
        not_if " dumpe2fs -h /dev/vgdata/datavol "
        end

    end

        directory "/export/home" do
                        owner "root"
                        group "root"
                        mode 0755
                        recursive true
                        action :create
                        not_if " /bin/mount | /bin/grep /export/home "
        end
        mount "/export/home" do
                        mount_point "/export/home"
                        device "/dev/vgdata/datavol"
                        fstype node[:icsmysql][:datadir_fs]
                        action [:mount, :enable]
                        not_if " /bin/mount | /bin/grep /export/home "
        end

#2. Install and start the mysql-server package
package node['icsmysql']['package_name'] do
  action :install
end

#3. Create the datadir, create /etc/my.cnf and start the mysqld service
service "mysqld" do
  	supports :status => true, :restart => true, :reload => true
  	action :nothing
end

        directory "/export/home/mysql" do
                        owner "mysql"
                        group "mysql"
                        mode 0755
                        recursive true
                        action :create
                        not_if { File.exists?("/export/home/mysql") } 
        end

template "/etc/my.cnf" do
  	source "my.cnf.erb"
  	owner "root" 
  	group "root"
  	mode "0644"
  	notifies :restart, resources(:service => "mysqld"), :immediately
end

#4. Set the root passwd for the db.

execute "assign-root-password" do
    command "\"#{node['icsmysql']['mysqladmin_bin']}\" -u root password \"#{node['icsmysql']['server_root_password']}\""
    action :run
    notifies :restart, resources(:service => "mysqld"), :immediately
    only_if "\"#{node['icsmysql']['mysql_bin']}\" -u root -e 'show databases;'"
end

