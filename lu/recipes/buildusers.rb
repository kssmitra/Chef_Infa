#
# Cookbook Name:: localusers
# Recipe:: default
#
# Copyright 2012, Informatica Corp.
# Author : Mitra Kaseebhotla
#
# All rights reserved - Do Not Redistribute
#

ohai "reload_passwd" do
	action :nothing
	plugin "passwd"
end


#node[:localusers][:buildusers].each_pair do |username,info|
#	user "#{username}" do
#		comment "#{username}"
#		uid #{info[0]}
#		gid info[1]
#		home "#{info[2]}"
#		shell "#{info[3]}"
##		password "#{info[4]}"
#		system true
#		action :create
#		notifies :reload, resources(:ohai => "reload_passwd"), :immediately
#	end
#end


localusers = data_bag("localbuildusers")
localusers.each do |username|
        userinfo = data_bag_item("localbuildusers", username)
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

