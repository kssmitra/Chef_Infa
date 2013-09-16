#
# Cookbook Name:: ics
# Recipe:: default
#
# Copyright 2012, Informatica Corp.
# Author: Mitra Kaseebhotla
#
# All rights reserved - Do Not Redistribute
#

#1. Create local FSs.
fs_index = 1
node[:ics][:external_devices].each  { |d|
#  	fs_index = node[:ics][:external_devices].to_a.index(d) + 1

#	puts "#{d}   #{fs_index}"

#	script "create_vg_lv" do
#		interpreter "bash"
#		user "root"
#		cwd "/etc"
#		flags "#{d}   #{fs_index}"
#		code <<-EOH
#			dev=$1
#			index=$2
#			pvcreate -f /dev/$dev
#			vgcreate vg0$index /dev/$dev
#			lvcreate -l 100%FREE -n datavol vg0$index
#    			mkfs.#{node.ics.datadir_fs} /dev/vg0$index/datavol
#		EOH
#
#		not_if " /sbin/pvs | /bin/grep /dev/$1 "
#	end
#		
#       only_if " /sbin/fdisk -l 2> /dev/null | /bin/grep /dev/#{d} "
    if File.exists? ("/dev/#{d}")

	execute "pvcreate -f /dev/#{d}" do
	not_if " /sbin/pvs | /bin/grep /dev/#{d} "
	end
	execute "vgcreate vg0#{fs_index} /dev/#{d}" do
	not_if " /sbin/vgs | /bin/grep vg0#{fs_index} "
	end
	execute "lvcreate -l 100%FREE -n datavol vg0#{fs_index}" do
	not_if " /sbin/lvs | /bin/grep vg0#{fs_index} | /bin/grep datavol "
	end
	execute "mkfs.#{node.ics.datadir_fs} /dev/vg0#{fs_index}/datavol" do
	not_if " dumpe2fs -h /dev/vg0#{fs_index}/datavol "
	end

    end

	if fs_index == 1
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
      			device "/dev/vg0#{fs_index}/datavol"
      			fstype node[:ics][:datadir_fs]
      			action [:mount, :enable]
			not_if " /bin/mount | /bin/grep /export/home "
    		end

	end

	fs_index = fs_index + 1

}

#2. Create local groups
ohai "reload_passwd" do
        action :nothing
        plugin "passwd"
end
ohai "reload_group" do
        action :nothing
        plugin "group"
end

node[:ics][:groups].each_pair do |groupname,gidnum|
        group "#{groupname}" do
                gid gidnum
                action :create
                system true
                notifies :reload, resources(:ohai => "reload_group"), :immediately
        end
end


#3. Create local users.
node[:ics][:users].each_pair do |username,info|
        user "#{username}" do
                comment "#{username}"
                uid "#{info[0]}"
                gid info[1]
                home "#{info[2]}"
                shell "#{info[3]}"
#               password "#{info[4]}"
                system true
                action :create
                notifies :reload, resources(:ohai => "reload_passwd"), :immediately
        end
        directory "#{info[2]}" do
                owner "#{username}"
                group info[1]
                action :create
        end
end

