#
# Cookbook Name:: localusers
# Recipe:: default
#
# Copyright 2012, Informatica Corp.
# Author : Mitra Kaseebhotla
#
# All rights reserved - Do Not Redistribute
#

# 0. Set-up the functions.
ohai "reload_passwd" do
	action :nothing
	plugin "passwd"
end
ohai "reload_group" do
	action :nothing
	plugin "group"
end

# 1. Create the groups
#node[:localusers][:groups].each_pair do |groupname,gidnum|
#	group "#{groupname}" do
#		gid gidnum
#    		action :create
#		system true
#    		notifies :reload, resources(:ohai => "reload_group"), :immediately
#	end
#end

localgroups = data_bag('localgroups')

#print "mitra",localgroups

localgroups.each do |groupname|
	groupinfo = data_bag_item('localgroups', groupname)
       group "#{groupinfo['id']}" do
               gid groupinfo['gid']
               action :create
               system true
               notifies :reload, resources(:ohai => "reload_group"), :immediately
       end
end

# 2. Create logins 
#node[:localusers][:users].each_pair do |username,info|
#	user "#{username}" do
#		comment "#{username}"
#		uid "#{info[0]}"
#		gid info[1]
#		home "#{info[2]}"
#		shell "#{info[3]}"
##		password "#{info[4]}"
#		system true
#		action :create
#		notifies :reload, resources(:ohai => "reload_passwd"), :immediately
#	end
#	directory "#{info[2]}" do
#		owner "#{username}"
#		group info[1]
#		action :create
#	end
#end

### Added for the hadoop installs

script "create_exporthome" do
        interpreter "bash"
        user "root"
        cwd "/"
        code <<-EOH
                /bin/mkdir -p /export/home 
        EOH
end



localusers = data_bag('localusers')
localusers.each do |username|
	userinfo = data_bag_item('localusers', username)
       user "#{userinfo['id']}" do
               comment userinfo['id']
               uid userinfo['uid']
               gid userinfo['gid']
               home userinfo['home']
               shell userinfo['shell']
#              password userinfo['password']
               system true
               action :create
               notifies :reload, resources(:ohai => "reload_passwd"), :immediately
       end
       directory "#{userinfo['home']}" do
               owner userinfo['id']
               group userinfo['gid']
               action :create
       end
end


# 3. Set-up ulimits
ulimitsinfo = data_bag_item('ulimits', "ulimits")
ulimitsinfo.delete("id")
template "/etc/security/limits.conf" do
	source "limits.conf.erb"
	owner "root"
        group "root"
        mode "0644"
	variables :ulimitsinfo => ulimitsinfo
end

script "change_etc_profile" do
        interpreter "bash"
        user "root"
        cwd "/etc"
        code <<-EOH
		/bin/cp	-p /etc/profile	/etc/profile.$(date +%F)
		/bin/sed -e 's/ulimit -S -c 0/ulimit -S -c unlimited/' /etc/profile.$(date +%F) > /etc/profile
	EOH

	not_if "grep 'ulimit -S -c unlimited' /etc/profile"
end

# 4. Set-up ssh keys for root and heroix users.

directory "/root/.ssh" do
	owner "root"
	group "root"
	mode "0755"
	action :create
end

cookbook_file "/root/.ssh/authorized_keys" do
	source "authorized_keys.root"
	mode "0644"
end 

directory "/export/home/heroix/.ssh" do
	owner "heroix"
	group "heroix"
	mode "0700"
	action :create
end

cookbook_file "/export/home/heroix/.ssh/authorized_keys" do
	source "authorized_keys.heroix"
	owner "heroix"
	group "heroix"
	mode "0644"
end 
